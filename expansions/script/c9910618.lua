--火打谷爱衣
function c9910618.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910618)
	e1:SetCost(c9910618.cost)
	e1:SetTarget(c9910618.target)
	e1:SetOperation(c9910618.operation)
	c:RegisterEffect(e1)
end
function c9910618.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910618.effilter(c,tp)
	return c:IsFaceup() and c:GetReasonPlayer()==tp
end
function c9910618.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910618.effilter,tp,0,LOCATION_REMOVED,1,nil,1-tp) end
end
function c9910618.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910618.effilter,tp,0,LOCATION_REMOVED,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetTargetRange(1,0)
		e1:SetCost(c9910618.costchk)
		e1:SetOperation(c9910618.costop)
		tc:RegisterEffect(e1)
		--accumulate
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(0x10000000+9910618)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e2:SetTargetRange(1,0)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c9910618.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,9910618)
	local mct=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	return Duel.CheckLPCost(tp,mct*100*ct)
end
function c9910618.costop(e,tp,eg,ep,ev,re,r,rp)
	local mct=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	Duel.PayLPCost(tp,mct*100)
end
