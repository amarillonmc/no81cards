--妖精骑士 兰斯洛特
local m = 60002348
local cm = _G["c" .. m]
cm.name = "妖精骑士 兰斯洛特"

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
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--ToHand
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, 60001106)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)

	--ToGraveAndToDeck
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE + CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, 70001106)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

function cm.splimit(e, c)
	return e:GetHandler()
end

function cm.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end

function cm.con1(e, c)
	if c == nil then return true end
	local tp = e:GetHandlerPlayer()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return false end
	local g = Duel.GetMatchingGroup(cm.filter1, tp, LOCATION_MZONE, LOCATION_MZONE, e:GetHandler())
	return g:CheckWithSumGreater(Card.GetAttack, 10000)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, c)
	local rg = Duel.GetMatchingGroup(cm.filter1, tp, LOCATION_MZONE, LOCATION_MZONE, e:GetHandler())
	local g = rg:SelectWithSumGreater(tp, Card.GetAttack, 10000)
	if #g > 0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	if not g then return end
	Duel.Remove(g, POS_FACEUP, REASON_COST)
	g:DeleteGroup()
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
	e1:SetDescription(aux.Stringid(m, 0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetCountLimit(1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function cm.con3(e, tp, eg, ep, ev, re, r, rp)
	return rp == tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function cm.filter3(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter3, tp, 0, LOCATION_EXTRA, 1, nil, e, tp) end
	Duel.SetChainLimit(cm.chlimit)
end

function cm.chlimit(e, ep, tp)
	return tp == ep
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
	local g1 = Duel.GetMatchingGroup(cm.filter3, tp, 0, LOCATION_EXTRA, nil)
	Duel.SendtoGrave(g1, REASON_EFFECT)
	Duel.SendtoDeck(g1, 1 - tp, 2, REASON_EFFECT)
end
