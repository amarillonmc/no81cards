--崩裂心智
local m=70001024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
	function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,14,REASON_EFFECT)
	Duel.DiscardDeck(tp,14,REASON_EFFECT)
end
	function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_DRAW)>0 then 
	Duel.DiscardDeck(1-tp,4,REASON_EFFECT)
	end
end