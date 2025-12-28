local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Summon/Spsummon (Draw 4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.sumcon)
	e1:SetOperation(s.regop4)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e1b,tp)
	--Activation (Draw 3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.actcon)
	e2:SetOperation(s.regop3)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--Set (Draw 3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetCondition(s.setcon)
	e3:SetOperation(s.regop3)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_MSET)
	Duel.RegisterEffect(e3b,tp)
	--To Grave in Main Phase (Draw 1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.tgcon)
	e4:SetOperation(s.regop1)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
	--Unified Settlement
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetOperation(s.solveop)
	e5:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e5,tp)
	--End Phase Balance
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetOperation(s.edop)
	e6:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e6,tp)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and eg:IsExists(Card.IsPreviousControler,1,nil,1-tp)
end
function s.regop4(e,tp,eg,ep,ev,re,r,rp)
	for i=1,4 do Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
	if not Duel.IsChainSolving() then s.solveop(e,tp,eg,ep,ev,re,r,rp) end
end
function s.regop3(e,tp,eg,ep,ev,re,r,rp)
	for i=1,3 do Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
	if not Duel.IsChainSolving() then s.solveop(e,tp,eg,ep,ev,re,r,rp) end
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsPreviousControler,nil,1-tp)
	for i=1,ct do Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
	if not Duel.IsChainSolving() then s.solveop(e,tp,eg,ep,ev,re,r,rp) end
end
function s.solveop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,id)
	if n>0 then
		Duel.ResetFlagEffect(tp,id)
		Duel.Draw(1-tp,n,REASON_EFFECT)
	end
end
function s.edop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local f1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local threshold=h1+f1+10
	if h2>threshold then
		local d=h2-threshold
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,d)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end