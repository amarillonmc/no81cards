--莱茵的黄金
function c22024890.initial_effect(c)
	-- 主效果
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024890+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22024890.condition)
	e1:SetTarget(c22024890.target)
	e1:SetOperation(c22024890.activate)
	c:RegisterEffect(e1)
end

function c22024890.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c22024890.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToGrave, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, LOCATION_ONFIELD, 0, e:GetHandler())
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local sg=Duel.SelectTarget(tp, Card.IsAbleToGrave, tp, LOCATION_ONFIELD, 0, 1, #g, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, sg, #sg, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, #sg)
end

function c22024890.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect, nil, e)
	
	if #g>0 then
		-- 送墓处理（不直接使用返回值）
		Duel.SendtoGrave(g, REASON_EFFECT)
		
		-- 获取实际送入墓地的有效卡（排除Token）
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(c22024890.gravefilter,nil)
		
		-- 执行抽卡
		if ct>0 and Duel.IsPlayerCanDraw(tp, ct) then
			Duel.BreakEffect()
			Duel.Draw(tp, ct, REASON_EFFECT)
		end
	end
end

-- 自定义过滤器：判断是否为有效送入墓地的卡
function c22024890.gravefilter(c)
	return c:IsLocation(LOCATION_GRAVE)
end