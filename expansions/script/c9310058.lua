--械龙铠·单调栈数据流
function c9310058.initial_effect(c)
	aux.AddMaterialCodeList(c,75124533)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,75124533),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9310058.splimit0)
	c:RegisterEffect(e0)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9310058.spcon)
	e1:SetOperation(c9310058.spcop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9310058,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9310058)
	e2:SetTarget(c9310058.sptg)
	e2:SetOperation(c9310058.spop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c9310058.tnval)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9310058,ACTIVITY_SPSUMMON,c9310058.counterfilter)
end
function c9310058.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_TUNER)
end
function c9310058.splimit0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or 
		   ((bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO and (not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)))
			 or (se:IsHasType(EFFECT_TYPE_ACTIONS) and Duel.GetCustomActivityCount(9310058,tp,ACTIVITY_SPSUMMON)==0))
end
function c9310058.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c9310058.spcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9310058.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9310058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_TUNER) and c:IsLocation(LOCATION_EXTRA)
end
function c9310058.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsType(TYPE_TUNER) and aux.AtkEqualsDef(c)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_CYBERSE)
end
function c9310058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_GRAVE
		if e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c9310058.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c9310058.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9310058.spfilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9310058.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
