--六花精 白玉兰
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.rltg)
	e2:SetOperation(s.rlop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.rlcon)
	c:RegisterEffect(e3)
end
function s.cefilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(s.cefilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.spfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceupEx()) and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.spfilter,1,REASON_COST,true,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroupEx(tp,s.spfilter,1,1,REASON_COST,true,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsSummonLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function s.rlfilter(c)
	return (c:IsFaceupEx() or c:IsLocation(LOCATION_EXTRA)) and c:IsReleasableByEffect() and not c:IsCode(id) and c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function s.rlfilter2(c)
	return c:IsReleasableByEffect() and c:IsRace(RACE_PLANT) 
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)>0 and (g:GetFirst():IsPreviousLocation(LOCATION_HAND) or g:GetFirst():IsPreviousLocation(LOCATION_ONFIELD)) and Duel.IsExistingMatchingCard(s.rlfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local sg=Duel.SelectMatchingCard(tp,s.rlfilter2,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
		end
	end
end
function s.rlcon(e,tp,eg,ep,ev,re,r,rp)
	local typ,race=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_TYPE,SUMMON_INFO_RACE)
	return typ&TYPE_MONSTER~=0 and race&RACE_PLANT~=0
end