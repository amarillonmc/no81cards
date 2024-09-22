--异天枝-亚夫结
function c22060130.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060130,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060130)
	e1:SetCondition(c22060130.condition)
	e1:SetCost(c22060130.cost)
	e1:SetOperation(c22060130.operation)
	c:RegisterEffect(e1)
	if not c22060130.global_flag then
		c22060130.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22060130.regop1)
		Duel.RegisterEffect(ge1,0)

		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(c22060130.regop2)
		Duel.RegisterEffect(ge2,0)

		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(c22060130.regop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function c22060130.regop1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_MONSTER) then
			Duel.RegisterFlagEffect(tp,22060131,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c22060130.regop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_SPELL) then
			Duel.RegisterFlagEffect(tp,22060132,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c22060130.regop3(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_TRAP) then
			Duel.RegisterFlagEffect(tp,22060133,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c22060130.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFlagEffect(tp,22060131)>0 and Duel.GetFlagEffect(tp,22060132)>0 and Duel.GetFlagEffect(tp,22060133)>0
end
function c22060130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22060130.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end