--彩虹泉水
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 捣蛋少女字段

function s.initial_effect(c)
	-- 永续魔法的基础激活效果（将卡放到场上）
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- 效果①：自己主要阶段，将场上1只捣蛋少女送去墓地，从双方墓地特召1只捣蛋少女
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)

	-- 效果②：支付1000LP，确认对方手卡
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_CONFIRM)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)

	-- 效果③：自己结束阶段，双方墓地合计3只捣蛋少女回卡组，然后自己抽1
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE + PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.cond3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end

-- 效果①的cost：将场上1只捣蛋少女怪兽送去墓地
function s.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SendtoGrave(g, REASON_COST)
end
function s.costfilter(c)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER)
end

-- 效果①的目标：从双方墓地选择1只捣蛋少女怪兽特殊召唤
function s.target1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end
function s.spfilter(c, e, tp)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.operation1(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- 效果②的cost：支付1000LP
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLPCost(tp, 1000) end
	Duel.PayLPCost(tp, 1000)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local opp = 1 - tp
	local hand = Duel.GetFieldGroup(opp, LOCATION_HAND, 0)
	if #hand > 0 then
		Duel.ConfirmCards(tp, hand)
	end
	Duel.ShuffleHand(1-tp)
end

-- 效果③的发动条件：自己的结束阶段
function s.cond3(e, tp, eg, ep, ev, re, r, rp)
	return tp == Duel.GetTurnPlayer()
end

function s.target3(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, nil)
	if chk == 0 then
		return #g >= 3
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 3, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end
function s.tdfilter(c)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.operation3(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, nil)
	if #g < 3 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local sg = g:Select(tp, 3, 3, nil)
	if #sg > 0 then
		Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1 - tp)
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end