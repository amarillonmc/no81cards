local m=40020025
local cm=_G["c"..m]
-- 雷皇龙 齐格普尔姆
function cm.initial_effect(c)
	-- ① 特殊召唤
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetCountLimit(1, m, EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	-- ② 战斗阶段破坏
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m, 0))
	e2:SetCategory(CATEGORY_DESTROY + CATEGORY_HANDES + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.descon)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	e2:SetCountLimit(1, m + 100)
	e2:SetHintTiming(0, TIMING_BATTLE_PHASE)
	c:RegisterEffect(e2)

	-- ③ 直接攻击
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(cm.dircon)
	c:RegisterEffect(e3)
end

-- ① LP ≤ 4000 时特召
function cm.spcon(e, c)
	if c == nil then return true end
	return Duel.GetLP(e:GetHandlerPlayer()) <= 4000 and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end

-- ② 战斗阶段 + 丢卡 + 无法对应
function cm.descon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
end

function cm.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsDiscardable()
			and Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local g = Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g, REASON_COST + REASON_DISCARD)
end

function cm.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAttackBelow(2500) end
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsAttackBelow, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, 2500)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, Card.IsAttackBelow, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, 2500)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function cm.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc, REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

-- ③ 对方场上无攻击表示怪兽时可直接攻击
function cm.dircon(e)
	return not Duel.IsExistingMatchingCard(Card.IsAttackPos, e:GetHandlerPlayer(), 0, LOCATION_MZONE, 1, nil)
end
