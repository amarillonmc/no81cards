function c98730117.initial_effect(c)
	aux.AddXyzProcedure(c,c98730117.xyzfilter,7,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98730117)
	e1:SetTarget(c98730117.pctg)
	e1:SetOperation(c98730117.pcop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,98730117)
	e2:SetCondition(c98730117.shcon)
	e2:SetTarget(c98730117.shtg)
	e2:SetOperation(c98730117.shop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98730117,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98731117)
	e3:SetCost(c98730117.shcost)
	e3:SetTarget(c98730117.shtg)
	e3:SetOperation(c98730117.shop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98731117)
	e4:SetCondition(c98730117.effcon)
	e4:SetTarget(c98730117.efftg)
	e4:SetOperation(c98730117.effop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98730117,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98731117)
	e5:SetTarget(c98730117.pentg)
	e5:SetOperation(c98730117.penop)
	c:RegisterEffect(e5)
end
c98730117.pendulum_level=7
function c98730117.xyzfilter(c)
	return c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c98730117.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsForbidden() and c:IsFaceup()
end
function c98730117.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c98730117.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c98730117.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98730117.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98730117.shcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_WIND)
end
function c98730117.shop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_PZONE,0,e:GetHandler(),ATTRIBUTE_WIND):GetFirst()
	if not pc then return end
	if Duel.SendtoDeck(c,nil,nil,REASON_EFFECT)~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98730117.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98730117.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98730117.shfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c98730117.shtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98730117.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98730117.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98730117.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98730117.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c98730117.efffilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsFaceup()
end
function c98730117.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c98730117.efffilter,tp,LOCATION_REMOVED,0,2,nil) end
end
function c98730117.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c98730117.efffilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c98730117.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98730117.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end