--超越星爆发
local s, id = GetID()
function s.initial_effect(c) 
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45055662, 0))
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, 45055662 + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45055662, 3))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, 45055662 + 1)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

function c45055662.tgfilter(c)
	return c:IsSetCard(0x6f5) and c:IsAbleToGrave()
end

function c45055662.thfilter(c)
	return c:IsSetCard(0x6f5) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end

function c45055662.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(c45055662.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
		local b2 = Duel.IsExistingMatchingCard(c45055662.thfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
		return b1 or b2
	end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
end
function c45055662.spop(e, tp, eg, ep, ev, re, r, rp)
	local b1 = Duel.IsExistingMatchingCard(c45055662.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(c45055662.thfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
	
	local op
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(45055662, 1))
		op = Duel.SelectOption(tp, 
			aux.Stringid(45055662, 2), 
			aux.Stringid(45055662, 3) 
		)
	elseif b1 then
		op = 0
	elseif b2 then
		op = 1
	else
		return
	end
	
	if op == 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g = Duel.SelectMatchingCard(tp, c45055662.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.SendtoGrave(g, REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, c45055662.thfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, g)
		end
	end
end
function c45055662.setcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function c45055662.setfilter(c)
	return c:IsCode(45055659) and c:IsLocation(LOCATION_GRAVE)
end

function c45055662.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(c45055662.setfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, nil, 1, tp, LOCATION_GRAVE)
end

function c45055662.setop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, c45055662.setfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	end
end
