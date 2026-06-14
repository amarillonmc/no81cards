--凛威之永恒流星
local s, id = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW + CATEGORY_HANDES + CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsRace, tp, LOCATION_MZONE, 0, 1, nil, RACE_DRAGON)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsPlayerCanDraw(tp, 2)
	end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)

	if Duel.Draw(tp, 2, REASON_EFFECT) == 0 then return end
	local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if #hand == 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local g = hand:Select(tp, 1, 1, nil)
	if #g == 0 then return end
	Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
	local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE, 0)
    e1:SetTarget(s.kaiserfilter)
    e1:SetValue(1000)
    Duel.RegisterEffect(e1, tp)
end

function s.kaiserfilter(e, c)
	return c:IsCode(46046112)
end

function s.extraatktarget(e, c)
	return c:IsRace(RACE_DRAGON)
end

function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function s.thfilter2(c, e)
	return c:IsSetCard(0x6f8) and c:IsAbleToHand() and c ~= e:GetHandler()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter2(chkc, e) end
	if chk == 0 then
		return Duel.IsExistingTarget(s.thfilter2, tp, LOCATION_GRAVE, 0, 1, nil, e)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.thfilter2, tp, LOCATION_GRAVE, 0, 1, 1, nil, e)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end