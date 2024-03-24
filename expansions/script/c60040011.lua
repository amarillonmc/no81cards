--繁荣的喷泉
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,0,0,1)
end