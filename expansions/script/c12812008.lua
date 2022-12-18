--恋爱即战争
local m=12812008
local cm=_G["c"..m]
function c12812008.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12812008+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost() 
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filtera(c)
	return c:IsCode(12812001) and c:IsAbleToHand()
end
function cm.filterb(c)
	return c:IsCode(12812002) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.filtera,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filterb,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,cm.filtera,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ng=Duel.SelectMatchingCard(tp,cm.filterb,tp,LOCATION_DECK,0,1,1,nil)
			if ng:GetCount()>0 then
			Duel.SendtoHand(ng,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ng)
			end
end