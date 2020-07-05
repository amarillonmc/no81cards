--决星壳·赤霄
function c79029501.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_FUSION),1)
	c:EnableReviveLimit()
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)  
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029501.efilter)
	e2:SetCondition(c79029501.imcon)
	c:RegisterEffect(e2)
	--lose lp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetOperation(c79029501.llop)
	c:RegisterEffect(e3)
end
function c79029501.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029501.fil(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c79029501.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029501.fil,1,nil)
end
function c79029501.llop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-x*1000)
end





