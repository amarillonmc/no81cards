--兵虫轨公 狡智螳螂
local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end

s.WEAPON_INSECT_PLACE_EVENT = EVENT_CUSTOM + 40020713

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.multitg)
	e2:SetOperation(s.multiop)
	c:RegisterEffect(e2)
	
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end
function s.szspfilter(c, e, tp)
	return c:IsFaceup() and s.WeaponInsect(c) 
		and (c:GetOriginalType() & TYPE_MONSTER) ~= 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.setfilter(c)
	return s.WeaponInsect(c) and not (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)) and not c:IsForbidden()
end

function s.multitg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.szspfilter(chkc, e, tp) end
	if chk == 0 then
		local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
		return ft > 0 and Duel.IsExistingTarget(s.szspfilter, tp, LOCATION_SZONE, 0, 1, nil, e, tp)
	end
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then ft = 1 end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.szspfilter, tp, LOCATION_SZONE, 0, 1, math.min(ft, 2), nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, #g, 0, 0)
end

function s.multiop(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetTargetCards(e)
	local sp_count = 0
	if #tg > 0 then
		local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
		if ft >= #tg and not (Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) and #tg > 1) then
			sp_count = Duel.SpecialSummon(tg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
	if sp_count == 0 then return end
	local can_pos = Duel.IsExistingMatchingCard(s.posfilter, tp, 0, LOCATION_ONFIELD, 1, nil)
	local can_set = Duel.GetLocationCount(tp, LOCATION_SZONE) >= 2 
		and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_HAND, 0, 1, nil)
		and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_GRAVE, 0, 1, nil)
	if can_pos and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local pos_g = Duel.SelectMatchingCard(tp, s.posfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
		if #pos_g > 0 then
			Duel.ChangePosition(pos_g, POS_FACEDOWN)
			if pos_g:GetFirst():IsType(TYPE_SPELL + TYPE_TRAP) then
				Duel.RaiseEvent(pos_g, EVENT_SSET, e, REASON_EFFECT, tp, tp, 0)
			end
		end
		if can_set then
			s.place_two_cards(e, tp)
		end
	else
		if can_set then
			Duel.BreakEffect()
			s.place_two_cards(e, tp)
		end
	end
end

function s.place_two_cards(e, tp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local hg = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local gg = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	
	local fg = Group.CreateGroup()
	fg:Merge(hg)
	fg:Merge(gg)
	
	if #fg == 2 then
		local tc = fg:GetFirst()
		while tc do
			Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
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
			Duel.RaiseSingleEvent(tc, s.WEAPON_INSECT_PLACE_EVENT, e, REASON_EFFECT, tp, tp, 0)
			tc = fg:GetNext()
		end
	end
end
