local m=188877
local cm=_G["c"..m]
cm.name="星魅的启示之弓-里苏"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetValue(cm.spval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-500)
	e2:SetCondition(function(e)return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4 end)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e)return e:GetHandler():GetSequence()==2 end)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2) and c:GetSequence()<5
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		local seq=aux.MZoneSequence(tc:GetSequence())
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|1<<(seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|1<<(seq+1) end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.spval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		local seq=aux.MZoneSequence(tc:GetSequence())
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|1<<(seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|1<<(seq+1) end
	end
	return 0,zone
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xca2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
