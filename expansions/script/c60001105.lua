local m = 60001105
local cm = _G["c" .. m]
cm.name = "妖精骑士 高文"

function cm.initial_effect(c)
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

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
	e2:SetCountLimit(1, m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)

	--Remove
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1, m + 10000000)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

function cm.splimit(e, c)
	return e:GetHandler()
end

function cm.filter1(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end

function cm.mzfilter(c)
	return c:GetSequence() < 5
end

function cm.con1(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	local mg1 = Duel.GetMatchingGroup(cm.filter1, tp, 0, LOCATION_ONFIELD, nil)
	local mg2 = Duel.GetMatchingGroup(cm.filter1, tp, LOCATION_ONFIELD, 0, nil)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	return ft > 0 and #mg1 + #mg2 >= 4
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 4, 4, nil, e, tp)
	Duel.SendtoGrave(g, REASON_COST)
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
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
	local g1 = Duel.GetDecktopGroup(1 - tp, 12)
	local g2 = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_HAND, nil)
	g1:Merge(g2)
	if chk == 0 then return #g1 > 0 end
	Duel.SetChainLimit(cm.chlimit)
end

function cm.chlimit(e, ep, tp)
	return tp == ep
end

function cm.filter3(c, e, tp)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
	local g1 = Duel.GetDecktopGroup(1 - tp, 12)
	local g2 = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_HAND, nil)
	local g3 = Duel.GetMatchingGroup(cm.filter3, tp, 0, LOCATION_HAND, nil)
	Duel.ConfirmCards(tp, g1)
	local g4 = g1:Filter(cm.filter3, nil, e, tp)
	Duel.ConfirmCards(tp, g2)
	g3:Merge(g4)
	Duel.Remove(g3, POS_FACEDOWN, REASON_EFFECT)
end
