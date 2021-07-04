--SNo.39 希望皇 霍普·桃源 
function c79029530.initial_effect(c)
--SNo.39 希望皇 霍普·桃源 
function c79029530.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,4,nil,nil,99)
	c:EnableReviveLimit() 
	--xyz only
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,79029530)
	e1:SetCondition(c79029530.condition)
	e1:SetCost(c79029530.cost)
	e1:SetTarget(c79029530.target)
	e1:SetOperation(c79029530.operation)
	c:RegisterEffect(e1) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c79029530.atkval)
	c:RegisterEffect(e2)
	--doule chance
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCost(c79029530.atkcost)
	e3:SetOperation(c79029530.atkop)
	c:RegisterEffect(e3)
end
c79029530.xyz_number=39
function c79029530.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end
function c79029530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029530.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029530.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029530.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c79029530.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79029530.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c79029530.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c79029530.atkfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local atk=g:GetSum(Card.GetAttack)
	return atk
end
function c79029530.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029530.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
