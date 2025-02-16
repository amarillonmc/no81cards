function c11845773.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11845773+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c11845773.cost)
	e1:SetTarget(c11845773.target)
	e1:SetOperation(c11845773.activate)
	c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(11845773,ACTIVITY_SPSUMMON,c11845773.counterfilter)
end
function c11845773.counterfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c11845773.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11845773,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11845773.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11845773.splimit(e, c, sump, sumtype, sumpos, targetp, se)
    return not c:IsRace(RACE_CYBERSE)
end

function c11845773.spfilter(c,e,tp)
	return c:IsSetCard(0xf80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c11845773.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11845773.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c11845773.tgfilter(c,mc)
	return c:IsSetCard(0xf80) and c:IsType(TYPE_MONSTER) and c:IsAttribute(mc:GetAttribute()) and not c:IsLevel(mc:GetLevel()) and c:IsAbleToGrave()
end
function c11845773.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11845773.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local tg=Duel.GetMatchingGroup(c11845773.tgfilter,tp,LOCATION_EXTRA,0,nil,g:GetFirst())
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11845773,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end