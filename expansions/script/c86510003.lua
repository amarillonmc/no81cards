--三千鸦
function c86510003.initial_effect(c)
	c:EnableCounterPermit(0x3653)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),aux.NonTuner(c86510003.mfilter),1)
	c:EnableReviveLimit() 
	--
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c86510003.ctcon)
	e1:SetOperation(c86510003.ctop)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(86510003,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,86510003+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c86510003.atcost)
	e3:SetTarget(c86510003.attg)
	e3:SetOperation(c86510003.atop1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86510003,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,16510003+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c86510003.atcost)
	e4:SetTarget(c86510003.attg)
	e4:SetOperation(c86510003.atop2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(86510003,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e5:SetProperty(EFFECT_FLAG_DELAY) 
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,26510003+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(c86510003.atcost)
	e5:SetTarget(c86510003.attg)
	e5:SetOperation(c86510003.atop3)
	c:RegisterEffect(e5)
end
function c86510003.mfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c86510003.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanAddCounter(0x3653,3)
end
function c86510003.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x3653,3)
end
function c86510003.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x3653,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x3653,1,REASON_COST)
end
function c86510003.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,86510003)==0 end  
	Duel.SetChainLimit(c86510003.chlimit)
end
function c86510003.chlimit(e,ep,tp)
	return tp==ep
end
function c86510003.atop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,86510003,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c86510003.actlimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)   
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then 
	--
	local tc=g:GetFirst()
	while tc do 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
	end
end
function c86510003.actlimit1(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c86510003.atop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,86510003,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c86510003.actlimit2)
	Duel.RegisterEffect(e1,tp)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c86510003.discon)
	e2:SetOperation(c86510003.disop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)  
end
function c86510003.actlimit2(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c86510003.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE) and re:GetHandlerPlayer()~=tp
end
function c86510003.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c86510003.atop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,86510003,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c86510003.actlimit3)
	Duel.RegisterEffect(e1,tp)   
end
function c86510003.actlimit3(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND)
end



