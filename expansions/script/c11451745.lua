--烬羽的残迹·珍妮丽丝
local m=11451745
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_FAIRY) and c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	for i=1,Duel.GetCurrentChain() do
		local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then return true end
	end
	return false
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	for i=1,Duel.GetCurrentChain() do
		local tgp,te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		if tgp~=tp then
			Duel.ChangeChainOperation(i,cm.repop(te:GetOperation()))
		end
	end
end
function cm.repop(_op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
				_op(e,tp,eg,ep,ev,re,r,rp)
			end
end