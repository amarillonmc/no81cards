--十化心世坏
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetValue(s.zones)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not p0 or not p1 then zone=zone-0x11 end
	return zone
end
function s.psfilter(c)
	return c:IsSetCard(0x19a) and c:IsAllTypes(TYPE_PENDULUM+TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceupEx()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(s.psfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
end
function s.rtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttack(1500) and c:IsDefense(2100) and c:IsFaceup()
end
function s.filter1(c,e,tp)
	return c:IsFaceup() and c:IsCode(56099748) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter11),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.filter11(c,e,tp,tc)
	return c:IsSetCard(0x198) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x1a0) and c:IsType(TYPE_MONSTER) and c:IsAttack(3000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.filter3(c)
	return c:IsFaceup() and c:IsCode(40785230) and c:IsCanAddCounter(0x69,12)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.psfilter),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if #g<=0 or not Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	local n=Duel.GetMatchingGroup(s.rtfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)
	local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,0,nil,e,tp)
	if n>0 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.Destroy(sg1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg11=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter11),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,sg1)
			Duel.SpecialSummon(sg11,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	if n>3 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg2,0,tp,tp,true,false,POS_FACEUP)
	end
	local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter3),tp,LOCATION_PZONE,0,nil)
	if n>9 and #g3>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sc3=g3:Select(tp,1,1,nil):GetFirst()
		sc3:AddCounter(0x69,12)
	end
end
