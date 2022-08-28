--烬羽的祈梦·琼诺贝兹
local m=11451746
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and c:GetOverlayCount()<2 end
	Duel.SetTargetCard(eg)
end
function cm.filter(c,e,tp)
	return c:IsRelateToEffect(e) and cm.cfilter(c,tp)
end
function cm.rmfilter(c,g)
	return c:IsAbleToRemove() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=eg:Filter(cm.filter,nil,e,1-tp)
	if #dg>0 and c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()<2 then
		local ct=math.min(2-c:GetOverlayCount(),#dg)
		local tg=dg:Select(1-tp,ct,ct,nil)
		Duel.Overlay(c,tg)
		Duel.ShuffleHand(1-tp)
	end
end