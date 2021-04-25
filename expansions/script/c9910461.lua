--韶光的怀恋 希尔维娅
function c9910461.initial_effect(c)
	c:EnableCounterPermit(0x950)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910461.ctcon)
	e1:SetTarget(c9910461.cttg)
	e1:SetOperation(c9910461.ctop)
	c:RegisterEffect(e1)
	--recover & draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9910461)
	e2:SetCondition(c9910461.regcon)
	e2:SetOperation(c9910461.regop)
	c:RegisterEffect(e2)
end
function c9910461.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910461.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1950,1) end
end
function c9910461.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1950,1)
	if g:GetCount()==0 then return end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1950,1)
	end
end
function c9910461.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910461.regop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetLabel(lp)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910461.rccon)
	e1:SetOperation(c9910461.rcop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function c9910461.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=e:GetLabel()
end
function c9910461.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910461)
	if Duel.GetLP(tp)<e:GetLabel() then
		local s1=e:GetLabel()-Duel.GetLP(tp)
		if Duel.IsPlayerAffectedByEffect(tp,9910467) then s1=2*s1 end
		local s2=Duel.Recover(tp,s1,REASON_EFFECT)
		local d=math.floor(s2/2000)
		if d>0 then Duel.Draw(tp,d,REASON_EFFECT) end
	else
		Duel.SetLP(tp,e:GetLabel())
	end
end
