--界域编织者 双轨驱动员
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	-- 融合召唤手续
	c:EnableReviveLimit()
	-- 定义融合素材 (用于图鉴显示和融合解除等判定)
	aux.AddFusionProcMixRep(c, true, true, s.matfilter, 2, 2)
	-- 启用灵摆属性
	aux.EnablePendulumAttribute(c, false)

	-- ===================
	-- 灵摆效果
	-- ===================
	
	-- ①：连接状态抗性
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	-- ===================
	-- 召唤规则 (接触融合)
	-- ===================
	
	-- 额外卡组特殊召唤手续
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)

	-- ===================
	-- 怪兽效果
	-- ===================
	
	-- ①：特召成功时，P区放置 + 丢手卡
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_HANDES) -- 主要是丢弃效果
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1, id)
	e3:SetTarget(s.pctg)
	e3:SetOperation(s.pcop)
	c:RegisterEffect(e3)

	-- ②：离场回P区
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.pencon)
	e4:SetTarget(s.pentg)
	e4:SetOperation(s.penop)
	c:RegisterEffect(e4)
end

-- 融合素材过滤：界域编织者怪兽
function s.matfilter(c, fc, sumtype, tp)
	return c:IsSetCard(SET_REALM_WEAVER, fc, sumtype, tp)
end

-- 灵摆效果：连接状态的怪兽不会被效果破坏
function s.indtg(e, c)
	return c:IsLinkState()
end

-- ===================
-- 接触融合逻辑
-- ===================

-- 过滤解放素材：界域编织者怪兽，在怪兽区或灵摆区，且可被解放
function s.rfilter(c, tp)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_PZONE))
		and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 -- 确保本身是怪兽卡（即使在P区当魔法）
		and c:IsFaceup() 
		and c:IsReleasable()
end

function s.sprcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	-- 必须有空位出额外怪兽
	if Duel.GetLocationCountFromEx(tp, tp, nil, c) <= 0 then return false end
	
	-- 检查是否存在满足条件的2只怪兽
	local g = Duel.GetMatchingGroup(s.rfilter, tp, LOCATION_MZONE + LOCATION_PZONE, 0, nil, tp)
	return g:GetCount() >= 2 and Duel.GetFlagEffect(tp,id)==0
end

function s.sprtg(e, tp, eg, ep, ev, re, r, rp, c)
	local sg = Duel.SelectMatchingCard(tp, s.rfilter, tp, LOCATION_MZONE + LOCATION_PZONE, 0, 2, 2, nil,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end

function s.sprop(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	if not g then return end
	Duel.SendtoDeck(g, nil, 2, REASON_COST + REASON_MATERIAL)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	g:DeleteGroup()
end

-- ===================
-- 效果①逻辑
-- ===================

-- 卡组过滤
function s.pcfilter(c)
	return c:IsSetCard(SET_REALM_WEAVER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end

function s.pctg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) -- 至少有1个P格子
		and Duel.IsExistingMatchingCard(s.pcfilter, tp, LOCATION_DECK, 0, 1, nil) 
	end
	-- 不设置CATEGORY_TOHAND等，因为是MoveToField，通常不属于Search类
end

function s.pcop(e, tp, eg, ep, ev, re, r, rp)
	-- 计算当前可用的P区数量
	local ct = 0
	if Duel.CheckLocation(tp, LOCATION_PZONE, 0) then ct = ct + 1 end
	if Duel.CheckLocation(tp, LOCATION_PZONE, 1) then ct = ct + 1 end
	
	if ct == 0 then return end
	
	-- 最多2张，受限于格子数量
	local max_count = math.min(2, ct)
	
	local g = Duel.GetMatchingGroup(s.pcfilter, tp, LOCATION_DECK, 0, nil)
	if #g == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	-- 使用 SelectUnselectGroup 来确保卡名不同 (aux.dncheck)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max_count)
	
	if #sg > 0 then
		local placed_count = 0
		for tc in aux.Next(sg) do
			if Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true) then
				placed_count = placed_count + 1
			end
		end
		
		-- 那之后，这个效果把2张卡放置的场合，选自己1张手卡丢弃。
		if placed_count == 2 then
			Duel.BreakEffect()
			if Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 then
				Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD)
			end
		end
	end
end

-- ===================
-- 效果②逻辑
-- ===================

function s.pencon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
		and c:IsFaceup() -- 使用 IsFaceup
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	end
end