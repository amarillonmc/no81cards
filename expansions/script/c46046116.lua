--肆斩之永恒流星
local s, id = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
end

function s.tgfilter(c)
	return c:IsSetCard(0x6f8) and not c:IsCode(id) and c:IsAbleToGrave()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and chkc ~= e:GetHandler() end
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
		local b2 = Duel.IsExistingTarget(function(c) return c:IsOnField() and c ~= e:GetHandler() end, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
		return b1 and b2
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, function(c) return c:IsOnField() and c ~= e:GetHandler() end, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 2, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g1 = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g1 == 0 then return end
	if Duel.SendtoGrave(g1, REASON_EFFECT) == 0 then return end
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if not tg or #tg == 0 then return end
	local dg = tg:Filter(Card.IsRelateToEffect, nil, e)
	if #dg > 0 then
		Duel.Destroy(dg, REASON_EFFECT)
	end
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