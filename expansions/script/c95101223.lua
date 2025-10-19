--失控磁盘 艾勒门特
function c95101223.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101223,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95101223.postg)
	e1:SetOperation(c95101223.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attack effect:extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101223,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCondition(c95101223.atkcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6bb0))
	c:RegisterEffect(e3)
	--defense effect:spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101223,1))
	e4:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101223.defcon)
	e4:SetTarget(c95101223.deftg)
	e4:SetOperation(c95101223.defop)
	c:RegisterEffect(e4)
end
function c95101223.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101223.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101223.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c95101223.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function c95101223.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c95101223.spfilter(c,e,tp)
	return c:IsSetCard(0x6bb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101223.defop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c95101223.spfilter,nil,e,tp)
	if g:GetCount()>0 and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(95101223,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		--g:Sub(sg)
	end
	Duel.ShuffleDeck(tp)
end
