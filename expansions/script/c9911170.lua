--幽愁溯雪
function c9911170.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9911170+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911170.target)
	e1:SetOperation(c9911170.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c9911170.thcost)
	e2:SetTarget(c9911170.thtg)
	e2:SetOperation(c9911170.thop)
	c:RegisterEffect(e2)
end
function c9911170.filter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x3958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9911170.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9911170.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9911170.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9911170.matfilter1(c,e)
	return c:IsFaceup() and c:IsSetCard(0x3958) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9911170.matfilter2(c)
	return c:IsSetCard(0x3958) and c:IsCanOverlay()
end
function c9911170.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c9911170.matfilter1,tp,LOCATION_MZONE,0,1,nil,e)
		and Duel.IsExistingMatchingCard(c9911170.matfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911170,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c9911170.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,e)
		if g2:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g3=Duel.SelectMatchingCard(tp,c9911170.matfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.Overlay(g2:GetFirst(),g3)
		end
	end
end
function c9911170.costfilter(c)
	return c:IsSetCard(0x3958) and c:IsAbleToGraveAsCost()
end
function c9911170.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911163)
	local b1=fe and Duel.IsExistingMatchingCard(c9911170.costfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and (b1 or b2) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9911163,1))) then
		Duel.Hint(HINT_CARD,0,9911163)
		fe:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9911170.costfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
end
function c9911170.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911170.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.DisableShuffleCheck()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
