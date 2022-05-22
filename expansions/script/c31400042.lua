local m=31400042
local cm=_G["c"..m]
cm.name="黄金强 黄金国巫妖"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.EnableChangeCode(c,95440946)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.splimcon)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distarget)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(cm.discon)
	e4:SetOperation(cm.disoperation)
	c:RegisterEffect(e4)
end
function cm.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function cm.splimit(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsLevel(10)
end
function cm.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.disfilter(c)
	return c:IsCode(95440946) and c:IsFaceup()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.disfilter,e:GetHandler(),LOCATION_MZONE,0,nil)>0
end
function cm.distarget(e,c)
	if c:IsSetCard(0x1142) or c==e:GetHandler() then return false end
	return c:IsType(TYPE_SPELL)
end
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:GetHandler():IsSetCard(0x1142) or re:GetHandler()==e:GetHandler() then return end
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end