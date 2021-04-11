--方舟骑士 泥岩
function c72410180.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72410180.sprcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c72410180.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c72410180.target)
	e3:SetValue(c72410180.filter)
	c:RegisterEffect(e3)
end
function c72410180.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c72410180.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and e:GetOwnerPlayer()==te:GetOwnerPlayer()
end
function c72410180.target(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetOwner() and c:IsPosition(POS_ATTACK)
end
function c72410180.filter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
