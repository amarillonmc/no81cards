--霸王的召唤
function c9951568.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9951568.condition)
	e1:SetTarget(c9951568.target)
	e1:SetOperation(c9951568.activate)
	c:RegisterEffect(e1)
end
function c9951568.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c9951568.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951568.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9951568.desfilter(c)
	return not c9951568.cfilter(c)
end
function c9951568.spfilter(c,e,tp,g)
	if not (c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		return Duel.GetMZoneCount(tp,g)>0
	end
end
function c9951568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9951568.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0
		and Duel.IsExistingMatchingCard(c9951568.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9951568.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c9951568.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function c9951568.gcheck(g,ft1,ft2,ft3,ect,ft)
	return aux.dncheck(g) and #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)<=ft1
		and g:FilterCount(c9951568.exfilter2,nil)<=ft2
		and g:FilterCount(c9951568.exfilter3,nil)<=ft3
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
end
function c9951568.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c9951568.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ect>0 and (ft2>0 or ft3>0) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9951568.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=sg:SelectSubGroup(tp,c9951568.gcheck,false,1,4,ft1,ft2,ft3,ect,ft)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP)
end