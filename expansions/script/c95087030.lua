--灰流丽出击
local s, id, o = GetID()

function s.initial_effect(c)
	-- 通常魔法效果
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.ashfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.ashfilter(c)
	return c:IsCode(14558127) and c:IsAbleToHand()
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	-- 检索灰流丽
	local g = Duel.GetMatchingGroup(s.ashfilter, tp, LOCATION_DECK, 0, nil)
	if #g > 0 then
		local tc = g:Select(tp, 1, 1, nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, tc)
		end
	end
	-- 解除本回合灰流丽的限制
	s.unlimit_ash(tp)
end

-- 解除灰流丽“一回合一次”限制的核心逻辑
function s.unlimit_ash(tp)
	local ash_code = 14558127
	if not s.unlimit_flag then s.unlimit_flag = {} end
	-- 若本回合已解除过限制，则仅重置现有灰流丽
	if s.unlimit_flag[tp] then
		local g = Duel.GetMatchingGroup(Card.IsCode, tp, 0xffff, 0, nil, ash_code)
		for tc in aux.Next(g) do
			tc:ResetEffect(tc:GetOriginalCode(),RESET_CARD)
			tc.initial_effect(tc)
		end
		return
	end
	s.unlimit_flag[tp] = true

	-- 保存原始的 SetCountLimit 函数
	s.original_SetCountLimit = Effect.SetCountLimit

	-- 重载 SetCountLimit：对当前玩家的灰流丽效果
	function Effect.SetCountLimit(e, count, code)
			s.original_SetCountLimit(e, 3, 14558127)
	end

	-- 重置当前玩家所有灰流丽，使其重新注册效果（触发重载后的 SetCountLimit）
	local g = Duel.GetMatchingGroup(Card.IsCode, tp, 0xffff, 0, nil, ash_code)
	for	tc in aux.Next(g) do
		if tc.initial_effect then
			s.rcard(tc)
		end
	end
	Effect.SetCountLimit = s.original_SetCountLimit
	-- 回合结束时恢复原始函数并清除标记
	local e2 = Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE + PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(s.fff)
	e2:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e2, tp)
end


function s.fff(e, tp, eg, ep, ev, re, r, rp)	
	local ash_code = 14558127
	local g = Duel.GetMatchingGroup(Card.IsCode, tp, 0xffff, 0, nil, ash_code)
	for tc in aux.Next(g) do
		s.rcard(tc)
	end
end


function s.rcard(c)
	local ini=s.initial_effect
	if c.initial_effect then
		s.initial_effect=function() end
		c:ReplaceEffect(id,0)
		c.initial_effect(c)
		s.initial_effect=ini
	end
end