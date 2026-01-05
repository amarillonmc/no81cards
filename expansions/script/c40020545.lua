--冥导魔皇帝 吕克莫诺斯
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
	e1:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW + CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
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

function s.InfernalLord(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.effcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.efftg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 4)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, 0, LOCATION_ONFIELD)

end

function s.effop(e, tp, eg, ep, ev, re, r, rp)
	local hg = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	local ct_hand = hg:GetCount()
	if ct_hand == 0 then return end

	local discarded_num = Duel.DiscardHand(tp, nil, 1, ct_hand, REASON_EFFECT + REASON_DISCARD)
	if discarded_num == 0 then return end

	if discarded_num == ct_hand then
		Duel.Draw(tp, 4, REASON_EFFECT)
	end

	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
	if discarded_num > 0 and #g >= discarded_num and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local sg = Duel.SelectMatchingCard(tp, nil, tp, 0, LOCATION_ONFIELD, discarded_num, discarded_num, nil)
		if #sg > 0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(sg, REASON_EFFECT)
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