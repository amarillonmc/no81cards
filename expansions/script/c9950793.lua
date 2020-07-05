--光之国-传说的战士
function c9950793.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950793+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950793.cost)
	e1:SetTarget(c9950793.target)
	e1:SetOperation(c9950793.activate)
	c:RegisterEffect(e1)
end
function c9950793.cfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950793.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950793.cfilter,tp,+LOCATION_HAND+LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950793.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,5,5,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950793.filter(c,e,tp)
	return c:IsCode(9950789,9951209,9950703,9951080) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950793.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA+LOCATION_DECK) and c9950793.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950793.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950793.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950793.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

