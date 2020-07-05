--永火煌灭龙
function c79029548.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.FilterBoolFunction(Card.IsCode,72896720),1,1)
	c:EnableReviveLimit()
	--PIERCE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	Duel.RegisterEffect(e1,tp)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029548,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)	
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c79029548.operation)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c79029548.icon)
	e3:SetValue(c79029548.efilter)
	c:RegisterEffect(e3)
	--cannot release
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(79029548,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c79029548.descon)
	e6:SetTarget(c79029548.destg)
	e6:SetOperation(c79029548.desop)
	c:RegisterEffect(e6)
end
function c79029548.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029548.icon(e)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_HAND,0)==0
end
function c79029548.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local x=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		  a=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.SendtoGrave(x,REASON_COST)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(a*1000)
		e2:SetReset(RESET_PHASE+PHASE_END)   
		c:RegisterEffect(e2)
end
end
function c79029548.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c79029548.desfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c79029548.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029548.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c79029548.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029548.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029548.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	x=Duel.GetMatchingGroupCount(c79029548.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,x*500,REASON_EFFECT)

end