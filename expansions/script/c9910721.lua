--远古造物 创孔海百合
require("expansions/script/c9910700")
function c9910721.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--chain set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910721)
	e1:SetCondition(c9910721.cscon)
	e1:SetCost(c9910721.cscost)
	e1:SetTarget(c9910721.cstg)
	e1:SetOperation(c9910721.csop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910722)
	e2:SetCondition(c9910721.setcon)
	e2:SetTarget(c9910721.settg)
	e2:SetOperation(c9910721.setop)
	c:RegisterEffect(e2)
end
function c9910721.cscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9910721.costfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToGraveAsCost()
end
function c9910721.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910721.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910721.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910721.cstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and Ygzw.SetFilter(rc,e,tp) end
	if rc:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c9910721.csop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Ygzw.Set(rc,e,tp)
	end
end
function c9910721.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910721.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Ygzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910721.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Ygzw.Set(c,e,tp) end
end
