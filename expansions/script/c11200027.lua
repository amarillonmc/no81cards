--乌冬
function c11200027.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200027+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200027.tg1)
	e1:SetOperation(c11200027.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200027,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11200027)
	e2:SetCost(c11200027.cost2)
	e2:SetOperation(c11200027.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200027.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end
--
function c11200027.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--
function c11200027.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
--
function c11200027.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>0 and dc<5 then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_1:SetProperty(EFFECT_FLAG_DELAY)
		e2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2_1:SetCondition(c11200027.con2_1)
		e2_1:SetOperation(c11200027.op2_1)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_1,tp)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2_2:SetCondition(c11200027.con2_2)
		e2_2:SetOperation(c11200027.op2_2)
		e2_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_2,tp)
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_3:SetCode(EVENT_CHAIN_SOLVED)
		e2_3:SetCondition(c11200027.con2_3)
		e2_3:SetOperation(c11200027.op2_3)
		e2_3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_3,tp)
	end
	if dc>4 then
		local e2_4=Effect.CreateEffect(c)
		e2_4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_4:SetProperty(EFFECT_FLAG_DELAY)
		e2_4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2_4:SetCondition(c11200027.con2_4)
		e2_4:SetOperation(c11200027.op2_4)
		e2_4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_4,tp)
		local e2_5=Effect.CreateEffect(c)
		e2_5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_5:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2_5:SetCondition(c11200027.con2_5)
		e2_5:SetOperation(c11200027.op2_5)
		e2_5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_5,tp)
		local e2_6=Effect.CreateEffect(c)
		e2_6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_6:SetCode(EVENT_CHAIN_SOLVED)
		e2_6:SetCondition(c11200027.con2_6)
		e2_6:SetOperation(c11200027.op2_6)
		e2_6:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_6,tp)
	end
end
--
function c11200027.cfilter2_1(c,sp)
	return c:GetSummonPlayer()==sp
end
function c11200027.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200027.cfilter2_1,1,nil,1-tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c11200027.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,700,REASON_EFFECT)
end
--
function c11200027.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200027.cfilter2_1,1,nil,1-tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c11200027.op2_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11200027,RESET_CHAIN,0,1)
end
--
function c11200027.con2_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11200027)>0
end
function c11200027.op2_3(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,11200027)
	Duel.ResetFlagEffect(tp,11200027)
	Duel.Recover(tp,n*700,REASON_EFFECT)
end
--
function c11200027.con2_4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200027.cfilter2_1,1,nil,1-tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c11200027.op2_4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,11200028)>=3 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,11200028,RESET_PHASE+PHASE_END,0,1)
end
--
function c11200027.con2_5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200027.cfilter2_1,1,nil,1-tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c11200027.op2_5(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11200029,RESET_CHAIN,0,1)
end
--
function c11200027.con2_6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11200029)>0
end
function c11200027.op2_6(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,11200029)
	local num=Duel.GetFlagEffect(tp,11200028)
	if n>3-num then n=3-num end
	Duel.ResetFlagEffect(tp,11200029)
	if n>0 then Duel.Draw(tp,1,REASON_EFFECT) end
	while n>0 do
		Duel.RegisterFlagEffect(tp,11200028,RESET_PHASE+PHASE_END,0,1)
		n=n-1
	end
end
--


