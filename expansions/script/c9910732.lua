--远古造物 菊石
require("expansions/script/c9910700")
function c9910732.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910732)
	e1:SetCost(c9910732.cost)
	e1:SetOperation(c9910732.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910733)
	e2:SetCondition(c9910732.setcon)
	e2:SetTarget(c9910732.settg)
	e2:SetOperation(c9910732.setop)
	c:RegisterEffect(e2)
end
function c9910732.cfilter(c,e,tp)
	return c:IsSetCard(0xc950) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c9910732.filter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c9910732.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910732.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910732.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910732.filter(c,e,tp)
	return c:IsSetCard(0xc950) and c:IsLevelAbove(5) and Ygzw.SetFilter(c,e,tp)
end
function c9910732.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910732.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then Ygzw.Set(tc,e,tp) end
end
function c9910732.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910732.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Ygzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910732.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Ygzw.Set(c,e,tp) end
end
