local s,id=GetID()

function s.initial_effect(c)
	-- 陷阱卡设置
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end

-- 发动条件：主要阶段1开始时
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1  and not Duel.CheckPhaseActivity()
end

-- 目标处理
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
end

-- 效果处理
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 效果1：回合结束时跳过下个回合
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.skipop)
	Duel.RegisterEffect(e1,tp)
	
	-- 效果2：战斗阶段结束时失去LP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetOperation(s.lpop)
	e2:SetCountLimit(1)
	Duel.RegisterEffect(e2,tp)
end

-- 跳过回合操作
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_TURN)
	e2:SetTargetRange(1,0)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.spcon)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() 
end
-- 失去LP操作
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local turn_count=Duel.GetTurnCount()
	local lose=turn_count*1000
			Duel.SetLP(tp,Duel.GetLP(tp)-lose)
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-lose)

end
