--幻想之城 哈雷穆特
function c60150509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(60150509,1))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1,60150509)
	e12:SetRange(LOCATION_FZONE)
	--e12:SetCondition(c60150509.condition)
	e12:SetTarget(c60150509.target)
	e12:SetOperation(c60150509.operation)
	c:RegisterEffect(e12)
	--检索
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(60150509,2))
	e23:SetType(EFFECT_TYPE_IGNITION)
	e23:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e23:SetRange(LOCATION_FZONE)
	e23:SetCountLimit(1,6010509)
	e23:SetCondition(c60150509.tgcon)
	e23:SetCost(c60150509.cost)
	e23:SetTarget(c60150509.thtg)
	e23:SetOperation(c60150509.thop)
	c:RegisterEffect(e23)
end
function c60150509.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c60150509.filter2(c)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60150509.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150509.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60150509.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150509.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150509.costfilter(c)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c60150509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150509.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150509.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60150509.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c60150509.filter(c,e,sp)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c60150509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150509.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c60150509.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150509.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end