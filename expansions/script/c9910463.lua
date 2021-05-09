--韶光的祈福 希尔维娅
function c9910463.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9950),2,2)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910463.ctcon)
	e1:SetTarget(c9910463.cttg)
	e1:SetOperation(c9910463.ctop)
	c:RegisterEffect(e1)
	--recover & todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9910463)
	e2:SetCondition(c9910463.regcon)
	e2:SetOperation(c9910463.regop)
	c:RegisterEffect(e2)
end
function c9910463.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910463.ctfilter(c)
	return c:IsLinkState() and c:IsCanAddCounter(0x1950,1)
end
function c9910463.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910463.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c9910463.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910463.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1950,1)
		tc=g:GetNext()
	end
end
function c9910463.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910463.regop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetLabel(lp)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910463.rccon)
	e1:SetOperation(c9910463.rcop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function c9910463.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=e:GetLabel()
end
function c9910463.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910463)
	if Duel.GetLP(tp)<e:GetLabel() then
		local s1=e:GetLabel()-Duel.GetLP(tp)
		if Duel.IsPlayerAffectedByEffect(tp,9910467) then s1=2*s1 end
		local s2=Duel.Recover(tp,s1,REASON_EFFECT)
		local d=math.floor(s2/2000)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
		if d<=0 then return end
		if d>g:GetCount() then d=g:GetCount() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,d,d,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	else
		Duel.SetLP(tp,e:GetLabel())
	end
end
