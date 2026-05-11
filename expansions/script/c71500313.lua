--付之一炬...
local s,id=GetID()
function s.initial_effect(c)
	-- 发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- 核心修复：直接使用十六进制数值，避开不存在的常量名
	-- 0x200 是 EFFECT_FLAG_CANNOT_DISABLE
	-- 0x400 是 EFFECT_FLAG_CANNOT_NEGATE
	e1:SetProperty(0x200 + 0x400) 
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	-- 防止发动和效果被无效 (双重保险：单体效果不受任何影响)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(0x200 + 0x400)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e2)
end

-- 检查场上卡片数量
function s.get_field_count()
	-- 0, LOCATION_ONFIELD, LOCATION_ONFIELD 表示双方场上合计
	return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return s.get_field_count()>=10 
	end
	-- 核心修复：手动禁止任何人对这张卡进行连锁 (等同于 EFFECT_FLAG_CANNOT_IN_CHAIN)
	Duel.SetChainLimit(s.chlimit)
	
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end

-- 禁止连锁的判定函数：返回 false 表示不允许任何人连锁
function s.chlimit(e,ep,tp)
	return false
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	-- 处理时再次检查条件
	if s.get_field_count()<10 then return end
	
	-- 1. 收集所有目标卡片 (使用 Group 传统操作)
	local all_cards=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	
	-- 合并自己额外卡组
	local ex_g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	all_cards:Merge(ex_g)
	
	-- 合并自己墓地
	local gy_g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	all_cards:Merge(gy_g)
	
	-- 合并全部里侧除外的卡
	local rm_g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	all_cards:Merge(rm_g)
	
	-- 2. 执行里侧除外
	if all_cards:GetCount()>0 then
		-- POS_FACEDOWN 为里侧表示
		Duel.Remove(all_cards,POS_FACEDOWN,REASON_EFFECT)
	end
	
	-- 3. 强制变成结束阶段 (跳过当前回合剩余所有阶段)
	Duel.BreakEffect()
	local turnp=Duel.GetTurnPlayer()
	
	-- 依次烧掉所有阶段，直到结束阶段
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	
	-- 强制锁定在结束阶段
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end