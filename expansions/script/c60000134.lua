--灵代 棱野七罪
local m=60000134
local cm=_G["c"..m]
cm.name="灵代 棱野七罪"
function cm.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.poscon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--Undestroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.poscon2)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.poscon(e)
	return e:GetHandler():IsDefensePos()
end
function cm.poscon2(e)
	return e:GetHandler():IsAttackPos()
end