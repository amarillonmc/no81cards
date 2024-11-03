--相剑·泰阿
function c91090042.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,91090042+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c91090042.target)
	e1:SetOperation(c91090042.activate)
	c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91090042,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,91090043)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c91090042.target2)
	e2:SetOperation(c91090042.activate2)
	c:RegisterEffect(e2)
end
function c91090042.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave() and c:IsSetCard(0x16b)
end
function c91090042.filter2(c)
	return  c:IsAbleToHand() and c:IsSetCard(0x16b)
end
function c91090042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91090042.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c91090042.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c91090042.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c91090042.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then 
		local g1=Duel.SelectMatchingCard(tp,c91090042.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT) end
	end
end
function c91090042.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and  c:IsSetCard(0x16b)
end
function c91090042.checkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c91090042.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c91090042.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c91090042.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c91090042.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end