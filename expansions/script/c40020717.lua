--拉·赫尔阿克提的兵虫神殿
local s, id = GetID()
s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end
s.RAHERAKHTY_CODE = 40020713
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.xyzcon)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
function s.rafilter(c)
	return c:IsCode(s.RAHERAKHTY_CODE) and not c:IsForbidden()
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local hasZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
	if hasZone
	   and Duel.IsExistingMatchingCard(s.rafilter, tp, LOCATION_DECK, 0, 1, nil)
	   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp, s.rafilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 then
			Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
		end
	end
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	end
end
function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
	c:RegisterEffect(e2, true)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(TYPE_SPELL + TYPE_QUICKPLAY)
	e3:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
	c:RegisterEffect(e3, true)
end
function s.xyzcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ph = Duel.GetCurrentPhase()
	local isBattle = ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
	local isSZoneNotField = c:IsLocation(LOCATION_SZONE) and c:GetSequence() < 5
	return isBattle and isSZoneNotField
end
function s.xyzfilter(c)
	return s.WeaponInsect(c) and c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end
function s.xyztg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.xyzfilter, tp, LOCATION_EXTRA, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end
function s.xyzop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.xyzfilter, tp, LOCATION_EXTRA, 0, nil)
	if #g > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tg = g:Select(tp, 1, 1, nil)
		Duel.XyzSummon(tp, tg:GetFirst(), nil)
	end
end
