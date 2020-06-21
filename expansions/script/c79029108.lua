--罗德岛·近卫干员-霜叶
function c79029108.initial_effect(c)
   aux.EnableDualAttribute(c)
   --atk up  
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetCode(EFFECT_UPDATE_ATTACK)
   e1:SetValue(1000)
   e1:SetCondition(aux.IsDualState)
   c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c79029108.target)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)  
	c:RegisterEffect(e3)   
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
end
function c79029108.target(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
