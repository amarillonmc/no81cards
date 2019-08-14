--奇妙障壁
function c10128008.initial_effect(c)
	--fuck monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128008,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10128008.condition)
	e1:SetOperation(c10128008.activate)
	c:RegisterEffect(e1)	
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6336))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)  
end
function c10128008.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c10128008.activate(e,tp,eg,ep,ev,re,r,rp)
	local ie=0x0
	if re:IsActiveType(TYPE_MONSTER) then ie=ie+0x1 end
	if re:IsActiveType(TYPE_SPELL) then ie=ie+0x2 end
	if re:IsActiveType(TYPE_TRAP) then ie=ie+0x4 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabel(ie)
	e1:SetValue(c10128008.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10128008.efilter(e,re)
	return re:IsActiveType(e:GetLabel()) and e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end