--界域编织者 路径邮差
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e0)	
	-- ①：回手并检索
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)  -- 卡名硬限制
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--effect gain
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_IGNITION) -- 启动效果，主要阶段发动
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)			  -- 软限制：1回合1次
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

-- 过滤卡组中的目标：界域编织者 + 灵摆怪兽 + 可加入额外
function s.exfilter(c)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and c:IsType(TYPE_PENDULUM) 
		and c:IsAbleToExtra()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 处理第一步：回到手卡
	-- 必须确保卡片还在场上且与效果相关
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 then
		-- 确认确实回到了手卡（或进入了额外卡组/墓地等合法的“离场”去向，但文案是回手，通常检查Location）
		if c:IsLocation(LOCATION_HAND) then
			-- 处理第二步：那之后，可以...
			local g = Duel.GetMatchingGroup(s.exfilter, tp, LOCATION_DECK, 0, nil)
			if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
				local sg = g:Select(tp, 1, 1, nil)
				-- 加入额外卡组表侧表示
				Duel.SendtoExtraP(sg, nil, REASON_EFFECT)
			end
		end
	end
end


function s.eftg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

-- 过滤条件：是“应答解析”或者“界域编织者”字段，且是魔法/陷阱卡，且能盖放
function s.setfilter(c)
	return (c:IsCode(33201756) or c:IsSetCard(SET_REALM_WEAVER))
		and c:IsType(TYPE_SPELL + TYPE_TRAP)
		and c:IsSSetable()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	-- 检查后场是否有空位 (Location Count > 0) 且卡组有符合条件的卡
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil) end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	-- 处理时再次检查格子数量
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
	-- 从卡组选择1张
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	
	if #g > 0 then
		-- 直接盖放
		Duel.SSet(tp, g:GetFirst())
		
		-- 如果是速攻魔法或陷阱卡，通常可以提示一下（SSet会自动处理，但有些脚本习惯加Confirm）
		-- 这里标准写法直接SSet即可，不需要ConfirmCards，因为SSet本身会展示给对手看（虽然是盖放，但来源是公开区域或已知检索，Ygopro底层处理了日志）
	end
end