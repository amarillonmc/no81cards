--孕育生命的季节 尤尼尔&埃尔
function c75081030.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,75081025,75081026,true,true)
	aux.AddContactFusionProcedure(c,c75081030.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c75081030.econ)
	--e1:SetTarget(c75081030.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)   
end
function c75081030.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c75081030.indtg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c75081030.econ(e)
	return Duel.IsEnvironment(75081027)
end