local m=53799152
local cm=_G["c"..m]
cm.name="大肠今"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local p=PLAYER_NONE
	if c:GetFlagEffect(m)>0 then p=tp end
	if c:GetFlagEffect(m+500)>0 then p=1-tp end
	if rp~=p and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		if rp==tp then
			c:ResetFlagEffect(m+500)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,0))
		else
			c:ResetFlagEffect(m)
			c:RegisterFlagEffect(m+500,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,1))
		end
	end
end
