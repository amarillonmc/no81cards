--N公司 中锤 罗佳
local m=43990053
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990053,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c43990053.ttcon)
	e1:SetOperation(c43990053.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--relive
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,43990053)
	e2:SetTarget(c43990053.sptg)
	e2:SetOperation(c43990053.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,43991053)
	e4:SetTarget(c43990053.cgtg)
	e4:SetOperation(c43990053.cgop)
	c:RegisterEffect(e4)
end
function c43990053.ctfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990053.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c43990053.ctfilter,tp,0,LOCATION_MZONE,nil)
	return minc<=1 and Duel.CheckTribute(c,1,1,mg,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c43990053.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c43990053.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.SelectTribute(tp,c,1,1,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c43990053.filter(c,e,tp)
	return c:IsSetCard(0x3510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43990053.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c43990053.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990053.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c43990053.cgfilter(c)
	return not c:IsRace(RACE_MACHINE) and  c:IsFaceup()
end
function c43990053.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c43990053.cgfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c43990053.cgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c43990053.cgfilter,tp,0,LOCATION_MZONE,1,3,nil)
end
function c43990053.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc and tc:IsRelateToEffect(e) and tc:IsFaceup() do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_MACHINE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end








