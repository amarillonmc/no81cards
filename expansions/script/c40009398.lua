--无止的G
function c40009398.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009398,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009398)
	e1:SetCondition(c40009398.spcon2)
	e1:SetCost(c40009398.cost)
	e1:SetOperation(c40009398.operation)
	c:RegisterEffect(e1)	
end
function c40009398.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c40009398.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c40009398.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40009398.drcon1)
	e1:SetOperation(c40009398.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c40009398.drcon1)
	e4:SetOperation(c40009398.drop1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	--counter2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetOperation(aux.chainreg)
	e5:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetCondition(c40009398.drcon2)
	e6:SetOperation(c40009398.drop2)
	e6:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e6)
   -- local e6=e1:Clone()
   -- e6:SetCode(EVENT_CHAINING)
   -- c:RegisterEffect(e6)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40009398.regcon)
	e2:SetOperation(c40009398.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--local e6=e2:Clone()
   -- e6:SetCode(EVENT_CHAINING)
   -- c:RegisterEffect(e6)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c40009398.drcon2)
	e3:SetOperation(c40009398.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c40009398.filter(c,tp)
	return c:GetSummonPlayer()==tp --or aux.chainreg
end
function c40009398.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c40009398.filter,1,nil,1-tp)
end
function c40009398.drop1(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.Draw(tp,h1+1,REASON_EFFECT)
	Duel.Draw(1-tp,h2+1,REASON_EFFECT)
end
function c40009398.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009398.filter,1,nil,1-tp)
end
function c40009398.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,40009398,RESET_CHAIN,0,1)
end
function c40009398.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,40009398)>0
end
function c40009398.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,40009398)
	Duel.ResetFlagEffect(tp,40009398)
		for i=1,n do 
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		Duel.Draw(tp,h1+1,REASON_EFFECT)
		Duel.Draw(1-tp,h2+1,REASON_EFFECT)
		end
end
