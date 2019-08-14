--虚无王座-爱莎
function c60150808.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60150808.mfilter,8,2)
	c:EnableReviveLimit()
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--e4:SetCondition(c60150808.spcon2)
	e4:SetValue(c60150808.tgvalue)
	c:RegisterEffect(e4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60150808.condition)
	e1:SetCost(c60150808.tdcost2)
	e1:SetTarget(c60150808.target)
	e1:SetOperation(c60150808.activate)
	c:RegisterEffect(e1)
end
function c60150808.mfilter(c)
	return c:IsSetCard(0x3b23)
end
function c60150808.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150808.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)
end
function c60150808.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (loc==LOCATION_HAND or loc==LOCATION_GRAVE)
	and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c60150808.cfilter(c)
	return (c:IsFaceup() or c:IsFacedown()) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c60150808.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	and Duel.IsExistingMatchingCard(c60150808.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150808.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c60150808.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c60150808.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end