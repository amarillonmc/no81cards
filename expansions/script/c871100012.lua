--暮光幼龙
function c871100012.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(871100012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,871100012)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c871100012.sptg)
	e2:SetOperation(c871100012.spop)
	c:RegisterEffect(e2)
end
function c871100012.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(871100012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c871100012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c871100012.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c871100012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c871100012.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end