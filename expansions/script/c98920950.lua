--极神诡皇 托尔
-- 极神圣帝 托尔
local s, id = GetID()

function s.initial_effect(c)
	-- Synchro summon procedure
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0x42), aux.NonTuner(Card.IsSynchroType, TYPE_SYNCHRO), 1)
	
	-- Effect 1: Excavate opponent's Spell/Trap when synchro summoned with "极神" material
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
	-- Effect 2: Special Summon "极星" monsters
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	
	-- Effect 3: Special Summon when destroyed
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon3)
	e3:SetTarget(s.sptg3)
	e3:SetOperation(s.spop3)
	c:RegisterEffect(e3)
end

-- Effect 1: Check if synchro material included "极神" monster
function s.rmcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():IsExists(Card.IsSetCard, 1, nil, 0x4b)
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetMatchingGroup(Card.IsType, tp, 0, LOCATION_ONFIELD, nil,TYPE_SPELL+TYPE_TRAP)
	if chk == 0 then return #g > 0 end
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, #g, 0, 0)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsType, tp, 0, LOCATION_ONFIELD, nil,TYPE_SPELL+TYPE_TRAP)
	if #g > 0 then
		Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
	end
end

-- Effect 2: Special Summon "极星" monsters
function s.spfilter2(c, e, tp)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP_DEFENSE)
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- Select locations to use
	local locations = LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE
	local ct = math.min(2, Duel.GetLocationCount(1 - tp, LOCATION_MZONE))
	if ct <= 0 then return end
	
	-- Special Summon to opponent's field
	local oppg = Group.CreateGroup()
	local names = {}
	for i = 1, ct do
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter2), tp, locations, 0, 1, 1, nil, e, tp)
		if #g == 0 then break end
		local tc = g:GetFirst()
		if names[tc:GetCode()] then
			break
		end
		names[tc:GetCode()] = true
		if Duel.SpecialSummonStep(tc, 0, tp, 1 - tp, false, false, POS_FACEUP_DEFENSE) then
			oppg:AddCard(tc)
		end
	end
	Duel.SpecialSummonComplete()
	
	-- Optional Special Summon to own field
	local selfct = oppg:GetCount()
	if selfct > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) >= selfct
		and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		
		local selfg = Group.CreateGroup()
		for i = 1, selfct do
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter2), tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
			if #g == 0 then break end
			local tc = g:GetFirst()
			if Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP) then
				selfg:AddCard(tc)
			end
		end
		Duel.SpecialSummonComplete()
	end
end

-- Effect 3: Special Summon when destroyed
function s.spfilter3(c, e, tp)
	return c:IsSetCard(0x4b) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, true)
		and c:IsLocation(LOCATION_EXTRA) or (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0)
end

function s.spcon3(e, tp, eg, ep, ev, re, r, rp)
	return rp ~= tp and e:GetHandler():IsPreviousControler(tp)
end

function s.sptg3(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter3, tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_GRAVE)
end

function s.spop3(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sc = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter3), tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, 1, nil, e, tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc, SUMMON_TYPE_SYNCHRO, tp, tp, true, true, POS_FACEUP)
		sc:CompleteProcedure()
	end
end

