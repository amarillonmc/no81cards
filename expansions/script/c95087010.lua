-- 反击陷阱：手札封锁
local s, id = GetID()

function s.initial_effect(c)
	
	-- 允许盖放回合发动（对方场上无卡时）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.incond)
	c:RegisterEffect(e0)

	-- 主要效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 条件：对方场上无卡
function s.incond(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)==0
end

-- 发动条件：自己主要阶段，对方发动的手卡怪兽效果
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	if Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 then return false end
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND)&loc~=0
end

-- 目标：不需要额外选择
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

-- 操作：无效效果，并施加封锁
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 无效那个效果
	if Duel.NegateEffect(ev) then
		-- 本回合对方不能发动任何手卡怪兽效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)  -- 对方
		e1:SetValue(s.handlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)

		-- 本次决斗自己不能发动任何手卡怪兽效果
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)  -- 自己
		e2:SetValue(s.handlimit)
		e2:SetReset(0)  -- 永久
		Duel.RegisterEffect(e2,tp)
	end
end

-- 禁止从手卡发动怪兽效果
function s.handlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_HAND)
end