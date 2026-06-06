--兵虫巨神 加农甲虫
local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end
s.RAHERAKHTY_CODE = 40020713
s.OMEGA_CODE = 40020839
function s.initial_effect(c)

	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),3,2)
	c:EnableReviveLimit()
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.damcost)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.setfilter(c)
	return s.WeaponInsect(c) and not (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))
end

function s.szfilter(c, e, tp)
	if c:GetSequence() >= 5 then return false end
	if c:IsAbleToHand() then return true end
	if (c:GetOriginalType() & TYPE_MONSTER) ~= 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then 
		return true 
	end
	return false
end

function s.rafilter(c)
	return c:IsCode(s.RAHERAKHTY_CODE) and c:IsFaceup() and c:IsLocation(LOCATION_PZONE)
end

function s.omegafilter(c)
	return c:IsCode(s.OMEGA_CODE)
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_SZONE, LOCATION_SZONE, 1, nil, TYPE_SPELL + TYPE_TRAP)
		local b2 = Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
		local b3 = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 
				   or Duel.IsExistingMatchingCard(s.szfilter, tp, LOCATION_SZONE, 0, 1, nil, e, tp)
		return b1 and b2 and b3
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 0, LOCATION_SZONE)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local dg = Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_SZONE, LOCATION_SZONE, 1, 1, nil, TYPE_SPELL + TYPE_TRAP)
	if #dg == 0 then return end
	local dc = dg:GetFirst()
	local isRa = dc:IsCode(s.RAHERAKHTY_CODE) and dc:IsFaceup() and dc:GetSequence() >= 5
	local hasOmega = Duel.IsExistingMatchingCard(s.omegafilter, tp, LOCATION_EXTRA, 0, 1, nil)
	local didOmegaSummon = false
	if isRa and hasOmega and Duel.SelectYesNo(tp, aux.Stringid(40020839, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local og = Duel.SelectMatchingCard(tp, s.omegafilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
		if #og > 0 then
			local rg = Group.FromCards(dc)
			local oc = og:GetFirst()
			oc:SetMaterial(rg)
			Duel.Overlay(oc, rg)
			Duel.SpecialSummon(oc, SUMMON_TYPE_XYZ, tp, tp, false, false, POS_FACEUP)
			oc:CompleteProcedure()
			didOmegaSummon = true
		end
	end
	if not didOmegaSummon then
		Duel.SendtoDeck(dg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	end
	Duel.BreakEffect()
	local place_zone = nil
	local hasEmpty = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	if not hasEmpty then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
		local sg = Duel.SelectMatchingCard(tp, s.szfilter, tp, LOCATION_SZONE, 0, 1, 1, nil, e, tp)
		if #sg > 0 then
			local sc = sg:GetFirst()
			local seq = sc:GetSequence()
			if s.replace_card(sc, e, tp) then place_zone = (1 << seq) end
		end
	else
		local sg = Duel.GetMatchingGroup(s.szfilter, tp, LOCATION_SZONE, 0, nil, e, tp)
		if #sg > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
			local sc = sg:Select(tp, 1, 1, nil):GetFirst()
			local seq = sc:GetSequence()
			if s.replace_card(sc, e, tp) then place_zone = (1 << seq) end
		end
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	local tc = g:GetFirst()
	if tc then
		Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true, place_zone or 0xff)
		local ot = tc:GetOriginalType()
		if (ot & TYPE_MONSTER) ~= 0 then
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1)
		else
			local e1a = Effect.CreateEffect(e:GetHandler())
			e1a:SetType(EFFECT_TYPE_SINGLE)
			e1a:SetCode(EFFECT_ADD_TYPE)
			e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1a:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
			e1a:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1a, true)
			local e1b = Effect.CreateEffect(e:GetHandler())
			e1b:SetType(EFFECT_TYPE_SINGLE)
			e1b:SetCode(EFFECT_REMOVE_TYPE)
			e1b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1b:SetValue(ot)
			e1b:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1b, true)
		end
		Duel.RaiseSingleEvent(tc, EVENT_CUSTOM + 40020713, e, REASON_EFFECT, tp, tp, 0)
	end
end

function s.replace_card(sc, e, tp)
	local canth = sc:IsAbleToHand()
	local cansp = (sc:GetOriginalType() & TYPE_MONSTER) ~= 0 
				  and sc:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
				  and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	if canth and cansp then
		if Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			return Duel.SendtoHand(sc, nil, REASON_EFFECT) > 0
		else
			return Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP) > 0
		end
	elseif canth then
		return Duel.SendtoHand(sc, nil, REASON_EFFECT) > 0
	elseif cansp then
		return Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP) > 0
	end
	return false
end

function s.damcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE + PHASE_DAMAGE)
	e1:SetOperation(s.damcheckop)
	Duel.RegisterEffect(e1, tp)
end

function s.damcheckop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(function(c) return s.WeaponInsect(c) and c:IsLocation(LOCATION_SZONE) end, tp, LOCATION_SZONE, 0, nil)
	local ct = #g
	if ct > 0 then
		Duel.Hint(HINT_CARD, 0, id)
		Duel.Damage(1 - tp, ct * 1600, REASON_EFFECT)
	end
end
