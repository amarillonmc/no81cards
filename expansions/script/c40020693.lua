--闪电·Z·松鼠
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
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(s.nsop)
	c:RegisterEffect(e2)
	
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.costfilter(c)
	return c:IsCode(40020683) and c:IsReleasable()
end
function s.repfilter(c)
	if not c:IsCode(40020683) then return false end
	if not c:IsAbleToGraveAsCost() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK then return true end
	if loc == LOCATION_EXTRA  then return c:IsFaceup() end
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

function s.thfilter(c)
	return s.EmperorBeast(c) 
		and c:IsType(TYPE_SPELL + TYPE_TRAP) 
		and c:IsAbleToHand()
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	c:SetMaterial(nil)
	
	if Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) > 0 then
		c:CompleteProcedure()
		Duel.BreakEffect()
		
		if Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
			if #g > 0 then
				Duel.SendtoHand(g, nil, REASON_EFFECT)
				Duel.ConfirmCards(1 - tp, g)
			end
		end
	end
end

function s.nsfilter(c)
	return s.EmperorBeast(c)
end

function s.nsop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND + LOCATION_MZONE, 0)
	e1:SetTarget(s.nsfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end
