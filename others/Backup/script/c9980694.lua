--昭和骑士·死光枪
function c9980694.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980694,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980694+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9980694.cost)
	e1:SetTarget(c9980694.target)
	e1:SetOperation(c9980694.activate)
	c:RegisterEffect(e1)
end
function c9980694.costfilter(c)
	return c:IsSetCard(0x6bc1) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9980694.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980694.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9980694.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9980694.thfilter(c)
	return c:GetSequence()<5 and c:IsAbleToHand()
end
function c9980694.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980694.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9980694.thfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9980694.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9980694.thfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980694,0))
	end
end