--废都界碑
function c67200927.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200927,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200927+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200927.target)
	e1:SetOperation(c67200927.activate)
	c:RegisterEffect(e1)  
  
end
function c67200927.filter1(c)
	return c:IsCode(67200924)
end
function c67200927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200927.activate(e,tp,eg,ep,ev,re,r,rp)
	--indes
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c67200905.filter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
