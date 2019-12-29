--暗黑进化
function c9950555.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9950555.cost)
	e1:SetTarget(c9950555.target)
	e1:SetOperation(c9950555.activate)
	c:RegisterEffect(e1)
end
function c9950555.filter1(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9950555.filter2,tp,0x13,0,1,nil,e,tp,c:GetCode())
end
function c9950555.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9950555.filter1,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9950555.filter1,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c9950555.filter2(c,e,tp)
	return c:IsSetCard(0x9ba6) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c9950555.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c9950555.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9950555.filter2),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end