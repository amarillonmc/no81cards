--AKF-圣护的夜莺-巫宴
function c82568086.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c82568086.fusionfilter1),aux.FilterBoolFunction(c82568086.fusionfilter2),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c82568086.splimit)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--sanctuary
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568086,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82568086.adcost)
	e3:SetCountLimit(1,82568086)
	e3:SetOperation(c82568086.activate)
	e3:SetValue(c82568086.rdval)
	c:RegisterEffect(e3)
end
function c82568086.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c82568086.fusionfilter1(c)
	return c:IsFusionSetCard(0x825) and c:IsRace(RACE_FIEND)
end 
function c82568086.fusionfilter2(c)
	return c:IsFusionSetCard(0x825) and c:IsFusionType(TYPE_FUSION)
end 
function c82568086.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,3,REASON_COST)
end
function c82568086.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e5:SetValue(c82568086.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e6:SetTarget(aux.TargetBoolFunction(c82568086.atkupfilter))
	e6:SetValue(1000)
	c:RegisterEffect(e6)
	
end
function c82568086.atkupfilter(c)
	return c:IsFaceup() and not c:IsCode(82567786) and not c:IsCode(82567787)  and not c:IsCode(82568087) and not c:IsCode(82568086)
end 
function c82568086.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner() and  te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end