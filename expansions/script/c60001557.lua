--洛伊德
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.atlimit)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
end
function cm.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup()
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer() and te:IsActivated()
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end