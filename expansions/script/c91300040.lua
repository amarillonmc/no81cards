--涅梅西斯～对价之赐～
local s,id,o=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		elseif tgp~=1-tp then
			local tc=te:GetHandler()
			dg:AddCard(tc)
		end
	end
	if chk==0 then return ng:GetCount()>0 and ng:GetCount()==dg:GetCount() end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local op0=te:GetOperation() or (function() end)
		local op1=function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(op0)
				op0(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if e:GetHandler():IsRelateToEffect(e) then
					Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
				end
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		te:SetOperation(op1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCountLimit(1)
		e1:SetLabel(i)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end