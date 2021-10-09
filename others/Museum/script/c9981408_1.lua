--凶饿毒的捕食者
function c9981408.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981408+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981408.cost)
	e1:SetTarget(c9981408.target)
	e1:SetOperation(c9981408.activate)
	c:RegisterEffect(e1)
end
function c9981408.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1
end
function c9981408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9981408.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9981408.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9981408.spfilter(c,e,tp)
	return c:IsSetCard(0x10f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9981408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	if chk==0 then
		e:SetLabel(0)
		return res and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c9981408.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c9981408.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9981408.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
		if g:GetCount()==2 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9981408.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9981408.splimit(e,c)
	return not c:IsRace(RACE_DRAGON+RACE_PLANT) and c:IsLocation(LOCATION_EXTRA)
end

