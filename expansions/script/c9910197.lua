--遨游天际的舞者
function c9910197.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910197)
	e1:SetCondition(c9910197.rmcon)
	e1:SetCost(c9910197.rmcost)
	e1:SetTarget(c9910197.rmtg)
	e1:SetOperation(c9910197.rmop)
	c:RegisterEffect(e1)
end
function c9910197.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910197.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b=not c:IsLocation(LOCATION_GRAVE)
		or (c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN))
	if chk==0 then return b and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9910197.rmfilter(c)
	return c:IsLinkState() and c:IsAbleToRemove()
end
function c9910197.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910197.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9910197.rmfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9910197.chlimit)
end
function c9910197.chlimit(e,ep,tp)
	return tp==ep or not e:GetHandler():IsType(TYPE_MONSTER) or not e:GetHandler():IsLinkState()
end
function c9910197.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910197.rmfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local rct=1
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(9910197,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,rct,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c9910197.retcon)
		e1:SetOperation(c9910197.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910197.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910197)==fid
end
function c9910197.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c9910197.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9910197.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c9910197.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	local flag=0
	while tc do
		if Duel.ReturnToField(tc) then flag=1 end
		tc=sg:GetNext()
	end
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,0,LOCATION_MZONE,nil)
	if flag==1 and ct>0 then
		Duel.Draw(1-tp,ct,REASON_EFFECT)
	end
end
