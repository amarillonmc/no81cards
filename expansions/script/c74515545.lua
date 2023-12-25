--人偶·神纳木弁天
function c74515545.initial_effect(c)
	aux.EnableDualAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74515545,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c74515545.con1)
	e1:SetCost(c74515545.ctcost1)
	e1:SetTarget(c74515545.cttg)
	e1:SetOperation(c74515545.ctop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74515545.con2)
	e2:SetCost(c74515545.ctcost2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74515545,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.IsDualState)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c74515545.sptg)
	e3:SetOperation(c74515545.spop)
	c:RegisterEffect(e3)
end
function c74515545.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74515545.ctcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c74515545.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74515545.ctcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74515545.ctfilter(c)
	return c:IsCanAddCounter(0x1745,1) and c:IsFaceup()
end
function c74515545.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74515545.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c74515545.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c74515545.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g then
		g:GetFirst():AddCounter(0x1745,1)
	end
end
function c74515545.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x745) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74515545.rlfilter(c,tp)
	return c:GetCounter(0x1745)>0 and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c74515545.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74515545.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c74515545.rlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,nil,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c74515545.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74515545.rlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	local tc=Duel.SelectMatchingCard(tp,c74515545.rlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
	Duel.Release(tc,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74515545.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c74515545.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c74515545.splimit(e,c)
	return not c:IsSetCard(0x745)
end
