local m=15004102
local cm=_G["c"..m]
cm.name="美洛希儿之弓"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.imcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsLevel(6)
end
function cm.atkval(e,c)
	local sg=c:GetOverlayGroup():Filter(cm.atkfilter,nil)
	local atk=0
	if sg:GetCount()~=0 then
		atk=sg:GetSum(Card.GetBaseAttack)
	end
	return atk
end
function cm.imcon(e)
	local c=e:GetHandler()
	local sg=c:GetOverlayGroup():Filter(cm.atkfilter,nil)
	return sg:GetCount()==c:GetOverlayGroup():GetCount()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end