--瞥视恶念
local m=70001025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
	function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,10,REASON_EFFECT)
end
	function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,10,REASON_EFFECT)
end