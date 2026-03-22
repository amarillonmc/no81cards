-- 捣蛋少女的哈哈镜（永续魔法）
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 捣蛋少女字段

function s.initial_effect(c)

	-- 永续魔法激活
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- 效果①：永续效果，攻击力上升
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e1:SetTarget(s.atktg)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	
	local e1b = Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1b:SetRange(LOCATION_SZONE)
	e1b:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e1b:SetTarget(s.atktg)
	e1b:SetValue(1)		  -- 不被战斗破坏
	c:RegisterEffect(e1b)

	-- 效果②：自己主要阶段，把手卡最多3张卡给对方，然后从卡组/墓地特召等量「捣蛋少女」
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_HANDES + CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id + 1)		  -- 一回合一次
	e2:SetCondition(s.spcon2)			-- 主要阶段限定
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)

	-- 效果③：自己回合结束时移动到对方魔法陷阱区
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE + PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.movecon)
	e3:SetTarget(s.movetg)
	e3:SetOperation(s.moveop)
	c:RegisterEffect(e3)
end

-- 效果①：攻击力上升目标（场上的捣蛋少女怪兽）
function s.atktg(e, c)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER)
end

-- 效果①：攻击力提升值 = 双方手卡总数 × 200
function s.atkval(e, c)
	local tp = c:GetControler()
	local handcount = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) + Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0)
	return handcount * 200
end

-- 效果②的条件：自己主要阶段
function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return ph == PHASE_MAIN1 or ph == PHASE_MAIN2
end

-- 效果②的目标：选择手卡中要交给对方的卡（最多3张）
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end

-- 效果②的操作
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 1. 选择手卡中最多3张卡交给对方
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOHAND)
	local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	local sg = hand:Select(tp, 1, 3, nil)
	local num = #sg
	if num == 0 then return end
	Duel.SendtoHand(sg, 1 - tp, REASON_EFFECT)

	-- 2. 从卡组或双方墓地特殊召唤 num 只「捣蛋少女」怪兽
	if num > 0 then
		local loc = LOCATION_DECK | LOCATION_GRAVE
		local available = Duel.GetMatchingGroup(s.spfilter, tp, loc, loc, nil, e, tp)
		if #available >= num and Duel.GetLocationCount(tp, LOCATION_MZONE) >= num then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg2 = available:Select(tp, num, num, nil)
			if #sg2 == num then
				for tc in aux.Next(sg2) do
					Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end

-- 特殊召唤筛选：捣蛋少女怪兽，且可被特殊召唤
function s.spfilter(c, e, tp)
	return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- 效果③的条件：自己的回合结束阶段
function s.movecon(e, tp, eg, ep, ev, re, r, rp)
	return tp == Duel.GetTurnPlayer()
end

function s.movetg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, e:GetHandler(), 1, 0, 0)
end

function s.moveop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		-- 移动到对方魔法陷阱区（当前控制者→对方）
		Duel.MoveToField(c, c:GetControler(), 1 - c:GetControler(), LOCATION_SZONE, POS_FACEUP, true)
	end
end