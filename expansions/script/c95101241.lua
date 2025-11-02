--失控磁盘 斩裂者
function c95101241.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101241,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95101241.postg)
	e1:SetOperation(c95101241.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attack effect:to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101241,1))
	e3:SetCategory(CATEGORY_DICE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95101241.atkcon)
	e3:SetTarget(c95101241.tdtg)
	e3:SetOperation(c95101241.tdop)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--defense effect:to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101241,1))
	e4:SetCategory(CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101241.defcon)
	e4:SetTarget(c95101241.tdtg)
	e4:SetOperation(c95101241.tdop)
	e4:SetLabel(2)
	c:RegisterEffect(e4)
end
function c95101241.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101241.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101241.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c95101241.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function c95101241.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c95101241.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if e:GetLabel()==2 then g=g:Filter(Card.IsSetCard,nil,0x6bb0) end
	if #g<dc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,dc,dc,nil)
	for tc in aux.Next(sg) do
		Duel.MoveSequence(tc,SEQ_DECKTOP)
	end
	Duel.SortDecktop(tp,tp,#sg)
	if e:GetLabel()==1 then
		for tc in aux.Next(sg) do
			Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		end
	end
end
