  --载音(注：狸子DIY)
function c77770026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77770026.condition)
	e1:SetOperation(c77770026.activate)
	c:RegisterEffect(e1)
end
function c77770026.cfilter(c)
	return c:IsFaceup() and c:IsCode(77770025)
end
function c77770026.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77770026.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77770026.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x234))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c77770026.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c77770026.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

