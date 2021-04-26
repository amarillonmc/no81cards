--幻异梦物-信号灯
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(71400047,0))
	e1:SetCondition(c71400047.con1)
	e1:SetOperation(c71400047.op1)
	c:RegisterEffect(e1)
end
function c71400047.con1(e,tp,eg,ep,ev,re,r,rp)
	return yume.YumeCon(e,tp) and Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.IsAbleToEnterBP()
end
function c71400047.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c71400047.atktarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_BP_TWICE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c71400047.atktarget(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x714))
end