--兵虫 磁轨枪翡翠蜈蚣

local s, id = GetID()
s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end

s.WEAPON_INSECT_PLACE_EVENT = EVENT_CUSTOM + 40020713

function s.initial_effect(c)

	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(0)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1, id + 1)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e4:SetCountLimit(1, id + 2)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.postg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1 - tp) and s.posfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.posfilter, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
	local g = Duel.SelectTarget(tp, s.posfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, 1, 0, 0)
end

function s.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end

function s.posop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc, POS_FACEDOWN_DEFENSE, POS_FACEDOWN, POS_FACEDOWN_DEFENSE, POS_FACEDOWN) > 0 then
			local can_remove = c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp, 1, REASON_EFFECT)
			local can_td = Duel.IsExistingMatchingCard(s.tdfilter, tp, 0, LOCATION_ONFIELD, 1, nil)
			if can_remove and can_td and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
				Duel.BreakEffect()
				if c:RemoveOverlayCard(tp, 1, 1, REASON_EFFECT) then
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
					local dg = Duel.SelectMatchingCard(tp, s.tdfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
					if #dg > 0 then
						Duel.SendtoDeck(dg, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.setcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	
	local ot = c:GetOriginalType()
	if (ot & TYPE_MONSTER) ~= 0 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
		c:RegisterEffect(e1)
	else
		local e1a = Effect.CreateEffect(c)
		e1a:SetType(EFFECT_TYPE_SINGLE)
		e1a:SetCode(EFFECT_ADD_TYPE)
		e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1a:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
		e1a:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
		c:RegisterEffect(e1a, true)
		
		local e1b = Effect.CreateEffect(c)
		e1b:SetType(EFFECT_TYPE_SINGLE)
		e1b:SetCode(EFFECT_REMOVE_TYPE)
		e1b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1b:SetValue(ot)
		e1b:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
		c:RegisterEffect(e1b, true)
	end
	
	Duel.RaiseSingleEvent(c, s.WEAPON_INSECT_PLACE_EVENT, e, REASON_EFFECT, tp, tp, 0)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	local c = e:GetHandler()
	return (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
		and c:IsLocation(LOCATION_SZONE) 
		and c:GetSequence() < 5
		and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end
