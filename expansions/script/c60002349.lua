--妖精骑士 崔斯坦
local m = 60002349
local cm = _G["c" .. m]
cm.name = "妖精骑士 崔斯坦"

function cm.initial_effect(c)
	c:EnableReviveLimit()

	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(1, 0)
	e0:SetTarget(cm.splimit)
	c:RegisterEffect(e0)
	local e00 = e0:Clone()
	e0:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e00)

	--Special summon
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--ToHand
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, 60001107)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, 70001107)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

function cm.splimit(e, c)
	return e:GetHandler()
end

function cm.filter1(c, e, tp)
	return not c:IsDisabled()
end

function cm.con1(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(cm.filter1, tp, LOCATION_PZONE, LOCATION_PZONE, nil)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	return ft > 0 and #mg >= 3
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp, c)
	local c = e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
	local g = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_PZONE, LOCATION_PZONE, 3, 3, nil, e, tp)
	local tc = g:GetFirst()
	while tc do
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e1:SetReset(RESET_EVENT + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e2)
		tc = g:GetNext()
	end
	Duel.SpecialSummon(c, 0, tp, tp, nil, nil, POS_FACEUP)
end

function cm.filter2(c, e, tp)
	return c:IsAttack(3950) and c:IsType(TYPE_MONSTER)
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter2, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, cm.filter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	Duel.SendtoHand(g, tp, REASON_EFFECT)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_SZONE, 0)
	e1:SetValue(cm.filter4)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function cm.filter4(e, te)
	return te:GetHandler():GetControler() ~= e:GetHandlerPlayer()
end

function cm.filter3(c)
	return c:IsReason(REASON_EFFECT)
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return eg:IsExists(cm.filter3, 1, nil, tp)
			and Duel.IsExistingMatchingCard(Card.IsSummonableCard, tp, LOCATION_DECK, 0, 1, nil) and Duel.IsPlayerCanDiscardDeck(tp, 1)
	end
	Duel.SetChainLimit(cm.chlimit)
end

function cm.chlimit(e, ep, tp)
	return tp == ep
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_LVRANK)
	local lv = Duel.AnnounceLevel(1 - tp)
	local tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
	while tc do
		Duel.ConfirmDecktop(tp, 1)
		if tc:GetLevel() == lv then
			Duel.SendtoGrave(tc, REASON_EFFECT)
			return
		end
		Duel.SendtoGrave(tc, REASON_EFFECT)
		tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
	end
end

