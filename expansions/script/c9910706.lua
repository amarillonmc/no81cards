--远古造物 中华先光海葵
require("expansions/script/c9910700")
function c9910706.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--to grave or remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910706)
	e1:SetCost(c9910706.tgcost)
	e1:SetTarget(c9910706.tgtg)
	e1:SetOperation(c9910706.tgop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910707)
	e2:SetCondition(c9910706.setcon)
	e2:SetTarget(c9910706.settg)
	e2:SetOperation(c9910706.setop)
	c:RegisterEffect(e2)
end
function c9910706.costfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToGraveAsCost()
end
function c9910706.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910706.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910706.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910706.tgfilter(c)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
end
function c9910706.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9910706.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910706.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910706.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c9910706.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c9910706.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910706.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Ygzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910706.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Ygzw.Set(c,e,tp) end
end
