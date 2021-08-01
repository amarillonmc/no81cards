--共和使 莉莉安·罗伊斯
local m=60000003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit() 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c60000003.cost)
	e1:SetOperation(c60000003.activate)
	c:RegisterEffect(e1)

end
function c60000003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c60000003.activate(tp)
	Duel.SelectOption(tp,aux.Stringid(60000003.0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60000003.0))
end