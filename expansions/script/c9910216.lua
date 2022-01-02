--天空漫步者 保坂实里
function c9910216.initial_effect(c)
	--spsummon link
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910216.sptg)
	e1:SetOperation(c9910216.spop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,9910216)
	e2:SetCondition(c9910216.sumcon)
	e2:SetCost(c9910216.sumcost)
	e2:SetTarget(c9910216.sumtg)
	e2:SetOperation(c9910216.sumop)
	c:RegisterEffect(e2)
end
function c9910216.cfilter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_PSYCHO)
		and (c:IsControler(tp) or c:GetSequence()>4)
end
function c9910216.cfilter2(c,tp,b1,b2,b3,b4,seq)
	if c:IsFacedown() or not c:IsRace(RACE_PSYCHO) then return false end
	local res1=b1 and c:GetSequence()==seq-1
	local res2=b2 and c:GetSequence()==seq+1
	local res3=b3 and ((c:IsControler(tp) and c:GetSequence()==5) or (c:IsControler(1-tp) and c:GetSequence()==6))
	local res4=b4 and ((c:IsControler(tp) and c:GetSequence()==6) or (c:IsControler(1-tp) and c:GetSequence()==5))
	return res1 or res2 or res3 or res4
end
function c9910216.get_zone(c,tp)
	local lg=Duel.GetMatchingGroup(c9910216.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local zone=0
	for lc in aux.Next(lg) do zone=bit.bor(zone,bit.band(lc:GetLinkedZone(tp),0x1f)) end
	local b1=c:IsLinkMarker(LINK_MARKER_LEFT)
	local b2=c:IsLinkMarker(LINK_MARKER_RIGHT)
	local b3=c:IsLinkMarker(LINK_MARKER_TOP)
	local b4=c:IsLinkMarker(LINK_MARKER_TOP_LEFT)
	local b5=c:IsLinkMarker(LINK_MARKER_TOP_RIGHT)
	if Duel.IsExistingMatchingCard(c9910216.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,false,b2,b5,false,0)
		then zone=bit.replace(zone,0x1,0) end
	if Duel.IsExistingMatchingCard(c9910216.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,b1,b2,b3,false,1)
		then zone=bit.replace(zone,0x1,1) end
	if Duel.IsExistingMatchingCard(c9910216.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,b1,b2,b4,b5,2)
		then zone=bit.replace(zone,0x1,2) end
	if Duel.IsExistingMatchingCard(c9910216.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,b1,b2,false,b3,3)
		then zone=bit.replace(zone,0x1,3) end
	if Duel.IsExistingMatchingCard(c9910216.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,b1,false,false,b4,4)
		then zone=bit.replace(zone,0x1,4) end
	return zone
end
function c9910216.spfilter(c,e,tp)
	local zone=c9910216.get_zone(c,tp)
	return zone~=0 and c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c9910216.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c9910216.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910216.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910216.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910216.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local zone=c9910216.get_zone(tc,tp)
		if zone~=0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910216.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910216.splimit(e,c)
	return not c:IsSetCard(0x955)
end
function c9910216.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end
function c9910216.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9910216.sumfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsSummonable(true,nil)
end
function c9910216.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910216.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910216.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910216.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
