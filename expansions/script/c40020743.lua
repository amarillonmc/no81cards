--翠风之霸皇 大锹牛若
local s,id=GetID()

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 1)
	e2:SetCondition(s.rmcon)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.Grandwalker, tp, LOCATION_PZONE, 0, 1, nil)
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
	if not c:IsRelateToEffect(e) then return end
	
	if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then

		s.removeAndChangeLevel(e, tp, true)
	end
end


function s.stfilter(c, tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
		and (c:GetPreviousTypeOnField() & (TYPE_SPELL + TYPE_TRAP)) ~= 0
		and c:GetReasonPlayer() == 1 - tp
end

function s.rmcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.stfilter, 1, nil, tp)
end

function s.rmcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_DISCARD)
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 2, 1 - tp, LOCATION_ONFIELD + LOCATION_GRAVE)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
	s.removeAndChangeLevel(e, tp, false)
end

function s.removeAndChangeLevel(e, tp, isOptional)
	if isOptional then
		if not Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then return end
	end
	
	local b1 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, nil)
	if not b1 or not b2 then return end
	
	Duel.BreakEffect()
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g1 = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g2 = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, 1, nil)
	
	g1:Merge(g2)
	if Duel.Remove(g1, POS_FACEUP, REASON_EFFECT) > 0 then

		if Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil)
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
			Duel.BreakEffect()

			local lv = Duel.AnnounceLevel(tp)

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
			local sg = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil)
			local tc = sg:GetFirst()
			if tc then

				local e1 = Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end


function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
	end
	

	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		Duel.SendtoHand(c, nil, REASON_EFFECT)
	end
end
