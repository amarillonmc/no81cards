--虚无的波动-爱莎
function c60150816.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60150816.mfilter,8,2)
	c:EnableReviveLimit()
	--cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e3:SetTarget(c60150816.distg)
    c:RegisterEffect(e3)
	--Negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60150816,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
    e2:SetCondition(c60150816.condition)
	e2:SetCost(c60150816.tdcost2)
    e2:SetTarget(c60150816.target)
    e2:SetOperation(c60150816.operation)
    c:RegisterEffect(e2)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c60150816.rmcost)
    e1:SetTarget(c60150816.target2)
    e1:SetOperation(c60150816.activate2)
    c:RegisterEffect(e1)
end
function c60150816.mfilter(c)
	return c:IsSetCard(0x3b23)
end
function c60150816.distg(e,c)
    return c:IsFacedown()
end
function c60150816.condition(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c60150816.cfilter(c)
	return (c:IsFaceup() or c:IsFacedown()) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c60150816.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150816.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150816.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoDeck(g,2,nil,REASON_COST+REASON_RETURN)
end
function c60150816.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if (re:GetHandler():IsAbleToRemove() or re:GetHandler():IsAbleToGrave())
		and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,eg,1,0,0)
    end
end
function c60150816.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		local tc=eg:GetFirst()
		if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			if Duel.SelectYesNo(tp,aux.Stringid(60150816,0)) then
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c60150816.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and (c:IsAbleToRemove() or c:IsAbleToGrave())
end
function c60150816.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150816.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c60150816.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c60150816.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c60150816.activate2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150816.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:FilterCount(Card.IsAbleToRemove,nil)>0 and g:FilterCount(Card.IsAbleToGrave,nil)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(60150816,0)) then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif not g:FilterCount(Card.IsAbleToRemove,nil)>0 and g:FilterCount(Card.IsAbleToGrave,nil)>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif g:FilterCount(Card.IsAbleToRemove,nil)>0 and not g:FilterCount(Card.IsAbleToGrave,nil)>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end