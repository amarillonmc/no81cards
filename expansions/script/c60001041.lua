--企鹅物流·先锋干员-德克萨斯·光影
function c60001041.initial_effect(c)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029017)
	c:RegisterEffect(e2)   
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c60001041.efilter)
	c:RegisterEffect(e3)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c60001041.actcon)
	e3:SetValue(c60001041.actlimit)
	c:RegisterEffect(e3)
	--change lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001041,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60001041.lpcon)
	e1:SetOperation(c60001041.lpop)
	c:RegisterEffect(e1)
end
function c60001041.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c60001041.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c60001041.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c60001041.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c60001041.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,16000)
	Duel.SetLP(1-tp,16000)
end
