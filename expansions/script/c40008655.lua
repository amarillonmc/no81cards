--反射圆阵
function c40008655.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008655,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,40008655)
	e2:SetCost(c40008655.spcost)
	e2:SetTarget(c40008655.sptg2)
	e2:SetOperation(c40008655.spop2)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c40008655.chainop)
	c:RegisterEffect(e3)	
end
function c40008655.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xf11) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c40008655.chainlm)
	end
end
function c40008655.chainlm(e,rp,tp)
	return tp==rp
end
function c40008655.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c40008655.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c40008655.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return zone
end
function c40008655.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11)
end
function c40008655.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11) and c:IsType(TYPE_LINK)
end
function c40008655.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xf11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,zone)
end
function c40008655.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rzone=c40008655.checkzone(tp)
	local zone=bit.band(rzone,0x1f)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40008655.filter(chkc,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40008655.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c40008655.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40008655.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40008655.spop2(e,tp,eg,ep,ev,re,r,rp)
	local rzone=c40008655.checkzone(tp)
	local zone=bit.band(rzone,0x1f)
	local tc=Duel.GetFirstTarget()
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40008655.spfilter2),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and zone~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end