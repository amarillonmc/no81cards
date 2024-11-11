--神龙 神曲
function c49811413.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811413.matfilter,1,1)
	--special summon 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,49811413)
	e1:SetCost(c49811413.spcost)
	e1:SetTarget(c49811413.sptg)
	e1:SetOperation(c49811413.spop)
	c:RegisterEffect(e1)
	--special summon 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811414)
	e2:SetCondition(c49811413.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811413.sptg2)
	e2:SetOperation(c49811413.spop2)
	c:RegisterEffect(e2)
end
function c49811413.matfilter(c)
	return c:IsLevel(4,5) and c:IsLinkRace(RACE_DRAGON)
end
function c49811413.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811413.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c49811413.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c49811413.spfilter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811413.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c49811413.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local code=0
		if tc:IsCode(62113340) then
			code=17985575
		elseif tc:IsCode(20277376) then
			code=67511500
		elseif tc:IsCode(10032958) then
			code=49811410
		end
		local g=Duel.GetMatchingGroup(c49811413.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,code)
		if #g>0 and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811413,0)) then
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c49811413.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceupEx()
end
function c49811413.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c49811413.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,62113340)
	and Duel.IsExistingMatchingCard(c49811413.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,20277376)
	and Duel.IsExistingMatchingCard(c49811413.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,10032958)
end
function c49811413.spfilter3(c,e,tp)
	return c:IsCode(32975247) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c49811413.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c49811413.spfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c49811413.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c49811413.spfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
