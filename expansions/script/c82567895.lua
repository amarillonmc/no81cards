--苦难摇篮
function c82567895.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c82567895.cost)
	e1:SetCondition(c82567895.condition)
	e1:SetOperation(c82567895.activate)
	c:RegisterEffect(e1)
end
function c82567895.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c82567895.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x825) 
end
function c82567895.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x825) 
end
function c82567895.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	local tc=Duel.GetAttacker()
	if not c:IsRelateToBattle() or not tc:IsRelateToBattle() then return end
	local g=Group.FromCards(c,tc)
	local mcount=0
	if tc:IsFaceup() then mcount=tc:GetOverlayCount() end
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(82567895,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c82567895.retop)
		Duel.RegisterEffect(e1,tp)
	  end
	Duel.BreakEffect()
		e:GetHandler():CancelToGrave()
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
		Duel.RaiseEvent(e:GetHandler(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
function c82567895.retfilter(c)
	return c:GetFlagEffect(82567895)~=0
end
function c82567895.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c82567895.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if Duel.ReturnToField(tc) and tc:IsFaceup() and tc:IsSetCard(0x825) then
			local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e3:SetValue(c82567895.rdval)
	tc:RegisterEffect(e3)
	 end
		tc=sg:GetNext()
	end
end
function c82567895.rdval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c82567895.filter,tp,LOCATION_MZONE,0,nil)*200
end