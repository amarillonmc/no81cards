local m=53796008
local cm=_G["c"..m]
cm.name="如常"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
end
function cm.repfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE) and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,e)
	Duel.SetTargetCard(g)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
	return true
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
