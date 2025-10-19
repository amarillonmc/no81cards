--失控磁盘 麦孙
function c95101225.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101225,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95101225.postg)
	e1:SetOperation(c95101225.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attack effect:set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101225,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95101225.atkcon)
	e3:SetTarget(c95101225.atktg)
	e3:SetOperation(c95101225.atkop)
	c:RegisterEffect(e3)
	--defense effect:search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101225,1))
	e4:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101225.defcon)
	e4:SetTarget(c95101225.deftg)
	e4:SetOperation(c95101225.defop)
	c:RegisterEffect(e4)
end
function c95101225.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101225.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101225.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c95101225.setfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsFaceupEx() and c:IsSSetable()
end
function c95101225.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101225.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c95101225.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95101225.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SSet(tp,g)
end
function c95101225.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function c95101225.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c95101225.thfilter(c)
	return c:IsSetCard(0x6bb0) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101225.defop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c95101225.thfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95101225,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end
