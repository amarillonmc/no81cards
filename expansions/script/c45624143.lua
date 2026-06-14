--永恒流星之辉炎 凯撒·双刃
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, s.tunfilter, aux.NonTuner(Card.IsRace,RACE_DRAGON), 1, 99)
	c:SetSPSummonOnce(id)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(46046112)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 0))
	e4:SetCategory(CATEGORY_TOHAND + CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.optg)
	e4:SetOperation(s.opop)
	c:RegisterEffect(e4)
end

function s.tunfilter(c)
	return c:IsRace(RACE_DRAGON)
end

function s.target(e,c)
	return c:IsRace(RACE_DRAGON)
end

function s.thfilter(c)
	return c:IsSetCard(0x6f8) and c:IsAbleToHand()
end

function s.rmfilter(c, tp, e)
	return c:IsFaceup() and c:IsControler(1 - tp) and c:IsCanBeDisabledByEffect(e)
end

function s.optg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
		local b2 = Duel.IsExistingMatchingCard(function(c) return s.rmfilter(c, tp, e) end, tp, 0, LOCATION_MZONE, 1, nil)
		return b1 or b2
	end
	local op = 0
	local b1 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(function(c) return s.rmfilter(c, tp, e) end, tp, 0, LOCATION_MZONE, 1, nil)
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 1), aux.Stringid(id, 2))
	elseif b1 then
		op = 0
	else
		op = 1
	end
	e:SetLabel(op)
	if op == 0 then
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED)
	else
		Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, 1 - tp, LOCATION_MZONE)
	end
end

function s.opop(e, tp, eg, ep, ev, re, r, rp)
	local op = e:GetLabel()
	if op == 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil)
		if #g > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, g)
		end
	else
		local c = e:GetHandler()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISABLE)
		local g = Duel.SelectMatchingCard(tp, function(card) return s.rmfilter(card, tp, e) end, tp, 0, LOCATION_MZONE, 1, 1, nil)
		if #g == 0 then return end
		local tc = g:GetFirst()
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc, RESET_TURN_SET)
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3 = Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT + RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
		end
	end
end