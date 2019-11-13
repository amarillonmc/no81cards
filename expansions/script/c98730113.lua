function c98730113.initial_effect(c)
	aux.AddXyzProcedure(c,c98730113.xyzfilter,7,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98730113)
	e1:SetTarget(c98730113.pctg)
	e1:SetOperation(c98730113.pcop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98730113)
	e2:SetCondition(c98730113.descon)
	e2:SetTarget(c98730113.destg)
	e2:SetOperation(c98730113.desop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98730113,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,98731113)
	e3:SetCost(c98730113.descost)
	e3:SetTarget(c98730113.destg)
	e3:SetOperation(c98730113.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98731113)
	e4:SetCondition(c98730113.effcon)
	e4:SetTarget(c98730113.efftg)
	e4:SetOperation(c98730113.effop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98730113,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98731113)
	e5:SetTarget(c98730113.pentg)
	e5:SetOperation(c98730113.penop)
	c:RegisterEffect(e5)
end
c98730113.pendulum_level=7
function c98730113.xyzfilter(c)
	return c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98730113.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsForbidden() and c:IsFaceup()
end
function c98730113.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c98730113.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c98730113.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98730113.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98730113.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_FIRE)
end
function c98730113.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_PZONE,0,e:GetHandler(),ATTRIBUTE_FIRE):GetFirst()
	if not pc then return end
	if Duel.SendtoDeck(c,nil,nil,REASON_EFFECT)~=1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98730113.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98730113.desfilter(c)
	return c:IsDestructable()
end
function c98730113.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c98730113.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98730113.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98730113.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98730113.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98730113.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c98730113.efffilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsFaceup()
end
function c98730113.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c98730113.efffilter,tp,LOCATION_REMOVED,0,2,nil) end
end
function c98730113.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c98730113.efffilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c98730113.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98730113.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end