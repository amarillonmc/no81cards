--
function c71000000.initial_effect(c)
	
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71000000,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c71000000.cost)
	e1:SetOperation(c71000000.operation)
	c:RegisterEffect(e1)
end
function c71000000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c71000000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c71000000.drcon1)
	e1:SetOperation(c71000000.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c71000000.regcon)
	e2:SetOperation(c71000000.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c71000000.drcon2)
	e3:SetOperation(c71000000.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c71000000.filter(c,sp)
	return c:IsSummonPlayer(sp) 
end
function c71000000.lvfilter(c,sp)
	return c:IsFaceup() and c:GetLevel()>0 
end
function c71000000.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71000000.filter,1,nil,1-tp)
		and not Duel.IsChainSolving()
end
function c71000000.drop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71000000.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c71000000.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71000000.filter,1,nil,1-tp)
		and Duel.IsChainSolving()
end
function c71000000.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,71000000,RESET_CHAIN,0,1)
end
function c71000000.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,71000000)>0
end
function c71000000.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,71000000)
	Duel.ResetFlagEffect(tp,71000000)
	local g=Duel.GetMatchingGroup(c71000000.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local td=g:GetFirst()
	while td do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(n)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		td:RegisterEffect(e1)
		td=g:GetNext()
	end
end
