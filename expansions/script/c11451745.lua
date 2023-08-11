--烬羽的残迹·珍妮丽丝
local cm,m=GetID()
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
	return c:IsLinkRace(RACE_FAIRY)
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
			te:SetOperation(cm.repop(te:GetOperation()))
			--[[local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetOperation(cm.ngop)
			e1:SetReset(RESET_CHAIN)
			e1:SetLabel(i)
			Duel.RegisterEffect(e1,tp)--]]
		end
	end
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetLabel() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then 
		Duel.ChangeChainOperation(0,cm.repop(re:GetOperation()))
	end
end
function cm.repop(_op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(_op)
				if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
				_op(e,tp,eg,ep,ev,re,r,rp)
			end
end