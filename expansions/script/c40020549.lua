--冥导弓手 石像鬼弓
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.initial_effect(c)
	c:EnableReviveLimit()

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.thcon1)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.thcon1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.thtg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.pcfilter1(c)
	return c:IsCode(40020547) and not c:IsForbidden()
		and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end

function s.thop1(e, tp, eg, ep, ev, re, r, rp)
	if Duel.Draw(tp, 1, REASON_EFFECT) == 0 then return end
	
	if Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) then
		local g = Duel.GetMatchingGroup(s.pcfilter1, tp, LOCATION_HAND + LOCATION_EXTRA, 0, nil)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
			local tc = g:Select(tp, 1, 1, nil):GetFirst()
			if tc then
				Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
			end
		end
	end
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.thfilter(c)
	return s.InfernalLord(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.thfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.thfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end
