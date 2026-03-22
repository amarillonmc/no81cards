-- 捣蛋少女的哈哈镜
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 捣蛋少女字段

function s.initial_effect(c)
	-- 永续陷阱的激活效果（将卡放到场上）
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- 效果①：解放场上1只捣蛋少女，破坏场上1张卡（2速）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1, id)   -- 共享计数
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)

	-- 效果②：展示手卡捣蛋少女，确认对方手卡，若无则自己受到4000伤害（2速）
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id)   -- 共享计数
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)

	-- 效果③：丢弃手卡1张原本是对方的卡，抽1张卡（2速）
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1, id)   -- 共享计数
	e3:SetCost(s.cost3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end

-- 效果①的cost：解放场上1只捣蛋少女怪兽
function s.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.releasefilter, tp, LOCATION_MZONE, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.releasefilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.Release(g, REASON_COST)
end
function s.releasefilter(c)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER)
end

-- 效果①的目标：选择场上1张卡破坏
function s.target1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.operation1(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end

-- 效果②的cost：展示手卡1张捣蛋少女卡给对方看
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.showfilter, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local g = Duel.SelectMatchingCard(tp, s.showfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	Duel.ConfirmCards(1 - tp, g)   -- 只展示，不消耗
end
function s.showfilter(c)
	return c:IsSetCard(s.named_setcode)
end

-- 效果②的目标：确认对方全部手卡，无捣蛋少女则受到伤害
function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, tp, 4000)
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local opp = 1 - tp
	local hand = Duel.GetFieldGroup(opp, LOCATION_HAND, 0)
	if #hand > 0 then
		Duel.ConfirmCards(tp, hand)   -- 向自己展示对方手卡
		local has_prank = false
		for tc in aux.Next(hand) do   -- 修复：使用 aux.Next 代替 :Iter()
			if tc:IsSetCard(s.named_setcode) then
				has_prank = true
				break
			end
		end
		if not has_prank then
			Duel.Damage(tp, 4000, REASON_EFFECT)
		end
	else
		-- 手牌为空，视为没有捣蛋少女卡，造成伤害
		Duel.Damage(tp, 4000, REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end

-- 效果③的cost：丢弃手卡1张原本是对方的卡
function s.cost3(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.discardfilter, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local g = Duel.SelectMatchingCard(tp, s.discardfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	Duel.SendtoGrave(g, REASON_COST + REASON_DISCARD)
end
function s.discardfilter(c)
	return c:GetOwner() ~= c:GetControler()
end

-- 效果③的目标：抽1张卡
function s.target3(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.operation3(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 1, REASON_EFFECT)
end