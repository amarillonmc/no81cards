--闪电·Z·鲸头鹳
local s, id = GetID()

s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

s.ZEUS_CODE = 40020683

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,40020683)	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMING_MAIN_END)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp
end

function s.costfilter(c)
	return c:IsCode(40020683) and c:IsReleasable()
end
function s.repfilter(c)
	if not c:IsCode(40020683) then return false end
	if not c:IsAbleToGraveAsCost() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK then return true end
	if loc == LOCATION_EXTRA then return c:IsFaceup() end
	return false
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_PZONE, 0, 1, nil)
	local b2 = Duel.IsPlayerAffectedByEffect(tp, 40020683)
		and Duel.GetFlagEffect(tp, 40020683) == 0
		and Duel.IsExistingMatchingCard(s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, nil)
	if chk == 0 then
		return b1 or b2
	end
	if b2 and (not b1 or Duel.SelectYesNo(tp, aux.Stringid(40020683, 0))) then
		Duel.RegisterFlagEffect(tp, 40020683, RESET_PHASE + PHASE_END, 0, 1)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, 1, nil)
		Duel.SendtoGrave(g, REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
		Duel.Release(g, REASON_COST)
	end
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spfilter(c, e, tp)
	return s.EmperorBeast(c) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	c:SetMaterial(nil)
	
	if Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) > 0 then
		c:CompleteProcedure()
		Duel.BreakEffect()
		
		if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		   and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
			if #g > 0 then
				Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
end

function s.ritfilter(c, tp)
	return c:IsControler(tp) 
		and c:IsSummonType(SUMMON_TYPE_RITUAL) 
		and s.EmperorBeast(c)
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.ritfilter, 1, nil, tp)
end

function s.samecodefilter(c, code)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsCode(code)
	else
		return c:IsCode(code)
	end
end

function s.thfilter(c, tp)
	if not s.EmperorBeast(c) or not c:IsAbleToHand() then return false end
	local code = c:GetCode()

	return not Duel.IsExistingMatchingCard(s.samecodefilter, tp, LOCATION_MZONE + LOCATION_GRAVE, 0, 1, nil, code)
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil, tp)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end
