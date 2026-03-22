-- 通常魔法：赠礼
local s, id = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_HAND)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOHAND)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToHand, tp, LOCATION_HAND, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, 1 - tp, REASON_EFFECT)
	end
end