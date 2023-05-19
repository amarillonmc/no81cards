local m=53760020
local cm=_G["c"..m]
cm.name="梦的委托者 探女"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.pcon1)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.ptg)
	e1:SetOperation(cm.pop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.pcon2)
	c:RegisterEffect(e2)
end
function cm.pcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsType(TYPE_EFFECT)end,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function cm.pcon1(e,tp,eg,ep,ev,re,r,rp)
	return not cm.pcon2(e,tp,eg,ep,ev,re,r,rp)
end
function cm.pfilter(c)
	return aux.IsSetNameMonsterListed(c,0x9538) and c:GetType()&0x20002==0x20002 and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOFIELD)
		local tg=sg:Select(1-tp,1,1,nil)
		if Duel.MoveToField(tg:GetFirst(),1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then Duel.MoveToField(Group.__sub(sg,tg):GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
