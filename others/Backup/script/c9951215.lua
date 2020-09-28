--光辉精神
function c9951215.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951215+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9951215.condition)
	e1:SetTarget(c9951215.target)
	e1:SetOperation(c9951215.activate)
	c:RegisterEffect(e1)
end
function c9951215.cfilter(c)
	return c:IsSetCard(0xcbd1) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c9951215.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951215.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9951215.spfilter(c,e,tp)
	return c:IsSetCard(0xcbd1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951215.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951215.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c9951215.setfilter(c)
	return c:IsSetCard(0xcbd1) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9951215.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9951215.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g2=Duel.GetMatchingGroup(c9951215.setfilter,tp,LOCATION_DECK,0,nil)
		if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9951215,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,tc)
		end
	end
end

