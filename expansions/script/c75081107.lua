--黑鹭的贵族 费尔迪南特
function c75081107.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081107,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75081107)
	e1:SetCondition(c75081107.spcon)
	e1:SetCost(c75081107.cost)
	e1:SetTarget(c75081107.sptg)
	e1:SetOperation(c75081107.spop)
	c:RegisterEffect(e1)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081107,1))
	--e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75081108+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c75081107.thcon)
	e2:SetTarget(c75081107.thtg)
	e2:SetOperation(c75081107.thop)
	c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e3) 
	if not c75081107.global_check then
		c75081107.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(c75081107.ndcon)
		ge2:SetOperation(c75081107.ndop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		Duel.RegisterEffect(ge3,1)
	end  
end
function c75081107.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c75081107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and c:IsDiscardable() end
	aux.GiveUpNormalDraw(e,tp)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c75081107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetTurnCount()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	--Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c75081107.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dc=Duel.Draw(p,ct,REASON_EFFECT)
end
--
function c75081107.filter(c)
	return c:IsSetCard(0xc754) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75081107.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and Duel.GetTurnPlayer()==tp
end
function c75081107.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75081107.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_TURN)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,1)
	e3:SetValue(aux.TRUE)
	e3:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_MAIN2+RESET_SELF_TURN)
	Duel.RegisterEffect(e4,tp)
	Duel.RegisterFlagEffect(tp,75081107,RESET_PHASE+PHASE_BATTLE,0,1)
end
function c75081107.ndcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081107)~=0
end
function c75081107.ndop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
	e1:SetOperation(c75081107.thop1)
	e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c75081107.thop1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end

