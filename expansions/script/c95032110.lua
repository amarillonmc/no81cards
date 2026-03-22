--捣蛋少女的邀请函
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 捣蛋少女字段

function s.initial_effect(c)
	-- 效果①：发动时的效果处理（检索 + 移动到对方场上）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)

	-- 效果②：自己主要阶段，支付2000LP，确认对方手卡，然后这张卡送去墓地（由原控制者使用）
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end

-- 效果①的检索过滤器
function s.searchfilter(c,e,tp)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.target1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.searchfilter, tp, LOCATION_DECK, 0, 1, nil,e,tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.activate1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 从卡组特殊召唤1只捣蛋少女怪兽
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.searchfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end

	-- 将这张卡移动到对方魔法·陷阱区域（表侧表示）
		Duel.MoveToField(c, tp, 1-tp, LOCATION_SZONE, POS_FACEUP, false)
end

-- 效果②的cost：支付2000LP
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLPCost(tp, 2000) end
	Duel.PayLPCost(tp, 2000)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 确认对方手卡（这里的对方是相对于原控制者，即当前对手）
	local opp = 1 - tp
	local hand = Duel.GetFieldGroup(opp, LOCATION_HAND, 0)
	if #hand > 0 then
		Duel.ConfirmCards(tp, hand)
	end
	Duel.ShuffleHand(1-tp)
	-- 将这张卡送去墓地
	if c:IsLocation(LOCATION_SZONE) then
		Duel.SendtoGrave(c, REASON_EFFECT)
	end
	
end