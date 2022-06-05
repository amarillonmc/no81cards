--远古造物 丽蛉
require("expansions/script/c9910700")
function c9910724.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910724)
	e1:SetCondition(c9910724.discon)
	e1:SetCost(c9910724.discost)
	e1:SetTarget(c9910724.distg)
	e1:SetOperation(c9910724.disop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910725)
	e2:SetCondition(c9910724.setcon)
	e2:SetTarget(c9910724.settg)
	e2:SetOperation(c9910724.setop)
	c:RegisterEffect(e2)
end
function c9910724.cfilter(c)
	return c:IsFacedown() and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9910724.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(c9910724.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9910724.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910724.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910724.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,c9910724.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1104,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c9910724.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910724.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Ygzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910724.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Ygzw.Set(c,e,tp) end
end
