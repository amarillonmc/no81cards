--九天九夜
--2021.06.14
local m=11451573
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,9,nil,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,9,9,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e1:SetValue(-9)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,9)
	Duel.RegisterEffect(e1,tp)
end