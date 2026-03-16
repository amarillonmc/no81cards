--贪欲时间之壶
-- 效果：自己从卡组抽2张卡，那之后，自己的游戏操作倒计时变成10秒
local s, id, o = GetID()

function s.initial_effect(c)
	-- 通常魔法效果
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		-- 检查是否可以抽2张卡
		return Duel.IsPlayerCanDraw(tp, 2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	-- 执行抽卡
	
	if Duel.ResetTimeLimit then
		Duel.Draw(p, d, REASON_EFFECT)
		Duel.BreakEffect()
		Duel.ResetTimeLimit(p, 10)
	else
		Debug.Message("当前环境不支持修改倒计时")
	end
end