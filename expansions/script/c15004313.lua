local m=15004313
local cm=_G["c"..m]
cm.name="愚者总按两遍铃"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15004313)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev<1 then return false end
	local te1,p1=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local te2,p2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p1==1-p2
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_CARD,0,15004313)
	local te1,p1=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local te2,p2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if p1==p2 then return end
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==6 then
		--local x=math.random(1,5)
		--Duel.SelectYesNo(tp,aux.Stringid(m,x))
		if p1==tp then Duel.NegateEffect(ev-1) end
		if p2==tp then Duel.NegateEffect(ev) end
	end
	if dc==3 or dc==4 then
		--local x=math.random(1,5)
		--Duel.SelectYesNo(tp,aux.Stringid(m,x))
		if p1==1-tp then Duel.NegateEffect(ev-1) end
		if p2==1-tp then Duel.NegateEffect(ev) end
	end
end