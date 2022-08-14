local m=31400107
local cm=_G["c"..m]
cm.name="怪童变幻龙"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_REMOVED,LOCATION_HAND+LOCATION_REMOVED)
	e1:SetValue(RACE_WYRM)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetValue(0)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.sccon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	e3:SetValue(12)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsRace(RACE_WYRM) and c:IsType(TYPE_PENDULUM)
end
function cm.sccon(e)
	local tc=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_PZONE,0,1,tc)
end
function cm.thfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end