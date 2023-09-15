local m=189133
local cm=_G["c"..m]
cm.name="墨工坊"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_HAND)
		e3:SetCondition(cm.th2con)
		e3:SetOperation(cm.th2op)
		Duel.RegisterEffect(e3,0)
	end
end
function cm.hfilter(c)
	return not c:IsPublic()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.hfilter,tp,0,LOCATION_HAND,nil)>0
end
function cm.qpfilter(e,c)
	return aux.IsCodeListed(c,189131)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.hfilter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()~=0 then
		local ct=1
		if Duel.IsPlayerAffectedByEffect(tp,189137) and Duel.GetFlagEffect(tp,189137)==0 and g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(189137,2)) then
			ct=2
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+189138,e,REASON_EFFECT,tp,1-tp,ev)
			Duel.RegisterFlagEffect(tp,189137,RESET_PHASE+PHASE_END,0,1)
		end
		local ag=g:RandomSelect(tp,ct)
		local ac=ag:GetFirst()
		while ac do
			ac:RegisterFlagEffect(189133,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=ag:GetNext()
		end
		Duel.ConfirmCards(tp,ag)
		Duel.BreakEffect()
		--act qp in hand
		Duel.RegisterFlagEffect(tp,189133,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetTarget(cm.qpfilter)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.phfilter(c)
	return c:IsPublic() and c:IsType(TYPE_SPELL)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and aux.IsCodeListed(re:GetHandler(),189131) and Duel.GetMatchingGroupCount(cm.phfilter,tp,0,LOCATION_HAND,nil)>0
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ac=re:GetHandler()
	if ac:IsRelateToEffect(re) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(LOCATION_HAND)
		ac:RegisterEffect(e1)
		ac:RegisterFlagEffect(189134,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.th2filter(c)
	return c:GetFlagEffect(189134)~=0
end
function cm.th2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.th2filter,1,nil)
end
function cm.th2op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.th2filter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end