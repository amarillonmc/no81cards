--界域编织者
local s, id = GetID()

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e0)	
	
	-- ===================
	-- 灵摆效果
	-- ===================
	
	-- ①：抗性与攻击力提升
	-- 不会被取对象
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE, 0) -- 仅限自己场上
	e1:SetTarget(s.indtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	-- 攻击力上升
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(s.indtg) -- 使用同样的对象过滤条件
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)

	-- ①：连锁对方怪兽效果发动，一时除外
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O) -- 诱发即时效果
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)

end

-- ===================
-- 灵摆效果处理函数
-- ===================


function s.thfilter(c)
	return c:IsSetCard(0xa328) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- 判断是否为“连接状态”的怪兽
function s.indtg(e, c)
	return c:IsLinkState()
end

-- 计算攻击力提升数值
function s.atkval(e, c)
	-- 统计全场（双方）连接状态的怪兽数量
	return Duel.GetMatchingGroupCount(Card.IsLinkState, 0, LOCATION_MZONE, LOCATION_MZONE, nil) * 300
end


-- 统计场上连接状态的怪兽数量
function s.link_count(tp)
	return Duel.GetMatchingGroupCount(Card.IsLinkState, tp, LOCATION_MZONE, 0, nil)
end

function s.rmcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 基本条件：自己处于连接状态 + 对方发动 + 是一次怪兽效果
	if not (c:IsLinkState() and rp == 1-tp and re:IsActiveType(TYPE_MONSTER)) then return false end
	
	-- 判定发动源是否在场上 ("对方把场上的怪兽的效果发动")
	local loc = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
	if not (loc == LOCATION_MZONE) then return false end
	
	-- 动态次数限制逻辑
	-- 获取这张卡表侧表示存在期间已使用的次数（通过FlagEffect记录）
	local used_count = c:GetFlagEffect(id)
	-- 获取当前允许的最大次数（场上连接状态怪兽数量）
	local max_count = s.link_count(tp)
	
	return used_count < max_count
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local rc = re:GetHandler()
	if chk == 0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() end
	
	-- 在Target阶段记录使用次数（相当于扣除一次使用权）
	-- RESET_EVENT + RESETS_STANDARD 包含了离场、里侧表示等重置条件，
	-- 完美符合“这张卡在场上表侧表示存在期间”的要求。
	e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, rc, 1, 0, 0)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
	local rc = re:GetHandler()
	-- 再次确认对象是否还在场上以及是否与效果相关
	if rc:IsRelateToEffect(re) then
		-- 一时除外逻辑
		if Duel.Remove(rc, POS_FACEUP, REASON_EFFECT + REASON_TEMPORARY) ~= 0 then
			-- 这种除外需要设置定时器让其回来
			local c = e:GetHandler()
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE + PHASE_END)
			e1:SetReset(RESET_PHASE + PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1, tp)
		end
	end
end

function s.retop(e, tp, eg, ep, ev, re, r, rp)
	-- 归还怪兽
	Duel.ReturnToField(e:GetLabelObject())
end