--烬羽的悲响·珞克莉尔
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
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
		local tgp,te,cid=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_CHAIN_ID)
		if tgp~=tp then
			local op=te:GetOperation()
			te:SetOperation(cm.repop(op,cid))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetCountLimit(1)
			e1:SetLabel(i)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op) end)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e2,tp)
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
function cm.repop(_op,cid)
	return function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(_op)
				local cid2=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
				if cid==cid2 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
				_op(e,tp,eg,ep,ev,re,r,rp)
			end
end