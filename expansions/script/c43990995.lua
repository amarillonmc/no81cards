--默墟天使 ·执棋者
function c43990995.initial_effect(c)
	aux.AddCodeList(c,43990998)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990995,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990995)
	e1:SetCondition(c43990995.icon)
	e1:SetCost(c43990995.spscost)
	e1:SetTarget(c43990995.spstg)
	e1:SetOperation(c43990995.spsop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c43990995.qcon)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990995,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,43990995-10)
	e2:SetTarget(c43990995.sptg)
	e2:SetOperation(c43990995.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--counter
	Duel.AddCustomActivityCounter(43990995,ACTIVITY_CHAIN,c43990995.chainfilter)
end
function c43990995.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(43990998)
end
function c43990995.icon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(43990995,0,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(43990995,1,ACTIVITY_CHAIN)==0
end
function c43990995.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(43990995,0,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(43990995,1,ACTIVITY_CHAIN)>0
end
function c43990995.tgfilter(c)
	return c:IsSetCard(0x9510) and c:IsAbleToGraveAsCost()
end
function c43990995.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and LOCATION_HAND+LOCATION_DECK or LOCATION_HAND 
	if chk==0 then return Duel.IsExistingMatchingCard(c43990995.tgfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990995.tgfilter,tp,loc,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990995.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c43990995.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990995.spfilter(c,e,tp,chk)
	return c:IsCode(43990992) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c43990995.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c43990995.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c43990995.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c43990995.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
