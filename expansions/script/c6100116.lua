--深空巡航者
local s, id = GetID()

function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.mat,1,1)
	c:EnableReviveLimit()
	 --indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function s.mat(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(id)
end
function s.lkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function s.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(s.lkfilter,1,nil)
end