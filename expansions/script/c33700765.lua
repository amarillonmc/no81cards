--妖幻战姬 浪人
if not pcall(function() require("expansions/script/c33700760") end) then require("script/c33700760") end
local m=33700765
local cm=_G["c"..m]
function cm.initial_effect(c)
	tfrsv.SSLimitEffect(c)
	tfrsv.ActivateEffect(c,cm.operation) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(tfrsv.columntg2)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)	
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.operation(c)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.valfilter)
	e2:SetValue(800)
	e2:SetCondition(tfrsv.ccon)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)  
end
function cm.valfilter(e,c)
	return c:IsSetCard(0x644a) or c:IsSetCard(0x344a)
end