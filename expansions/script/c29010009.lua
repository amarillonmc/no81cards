--深海的引导
function c29010009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29010009+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e1:SetCost(c29010009.cost)
	e1:SetTarget(c29010009.target)
	e1:SetOperation(c29010009.activate)
	c:RegisterEffect(e1)
end
function c29010009.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c29010009.filter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c29010009.filter(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29010009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end
function c29010009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29010009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29010009.setfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c29010009.cfilter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29010009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29010009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		local g2=Duel.GetMatchingGroup(c29010009.setfilter,tp,LOCATION_DECK,0,nil)
		if g2:GetCount()>0 and Duel.IsExistingMatchingCard(c29010009.cfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29010009,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	end
end