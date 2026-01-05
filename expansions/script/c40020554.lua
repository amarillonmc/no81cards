--冥导显现
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.hades_filter(c)
	return c:IsCode(40020547) and (c:IsFaceup() or c:IsLocation(LOCATION_PZONE))
		and (c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_PZONE))
end

function s.check_hades_condition(tp)
	return Duel.IsExistingMatchingCard(s.hades_filter, tp, 
		LOCATION_ONFIELD + LOCATION_PZONE + LOCATION_EXTRA, 0, 1, nil)
end

function s.mat_level_func(c, rc)
	if c:IsLocation(LOCATION_PZONE) then
		return c:GetOriginalLevel()
	else
		return c:GetRitualLevel(rc)
	end
end

function s.mat_filter(c)
	if not c:IsReleasable() then return false end
	return c:IsLocation(LOCATION_HAND + LOCATION_MZONE + LOCATION_PZONE)
end

function s.rit_filter(c, e, tp, m)
	if not (c:IsRace(RACE_SPELLCASTER) and bit.band(c:GetType(), TYPE_RITUAL + TYPE_MONSTER) == TYPE_RITUAL + TYPE_MONSTER) then return false end
	
	if not c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true) then return false end
	
	local is_hand = c:IsLocation(LOCATION_HAND)
	local is_grave = c:IsLocation(LOCATION_GRAVE)
	
	if is_grave then

		if not (s.check_hades_condition(tp) and s.InfernalLord(c)) then return false end
	elseif not is_hand then
		return false
	end
	
	local mg = m:Clone()
	if c:IsLocation(LOCATION_HAND) then

	elseif c:IsLocation(LOCATION_GRAVE) then
		mg:RemoveCard(c)
	end
	
	if mg:GetCount() == 0 then return false end
	
	return mg:CheckWithSumGreater(s.mat_level_func, c:GetLevel(), c)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local mg = Duel.GetRitualMaterial(tp)
		local pg = Duel.GetMatchingGroup(s.mat_filter, tp, LOCATION_PZONE, 0, nil)
		mg:Merge(pg)
		
		local loc = LOCATION_HAND
		if s.check_hades_condition(tp) then loc = loc + LOCATION_GRAVE end
		
		return Duel.IsExistingMatchingCard(s.rit_filter, tp, loc, 0, 1, nil, e, tp, mg)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local mg = Duel.GetRitualMaterial(tp)
	local pg = Duel.GetMatchingGroup(s.mat_filter, tp, LOCATION_PZONE, 0, nil)
	mg:Merge(pg)
	
	local loc = LOCATION_HAND
	if s.check_hades_condition(tp) then loc = loc + LOCATION_GRAVE end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local tg = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.rit_filter), tp, loc, 0, 1, 1, nil, e, tp, mg)
	local tc = tg:GetFirst()
	
	if tc then
		if mg:IsContains(tc) then mg:RemoveCard(tc) end

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		local mat = mg:SelectWithSumGreater(tp, s.mat_level_func, tc:GetLevel(), tc)
		
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		
		Duel.BreakEffect()
		Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP)
		tc:CompleteProcedure()
	end
end
