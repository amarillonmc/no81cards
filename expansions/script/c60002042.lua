--Re:SURGUM 征服者之心
local m=60002042
local cm=_G["c"..m]
cm.name="Re:SURGUM 征服者之心"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x62d))
	e3:SetValue(cm.indesval)
	c:RegisterEffect(e3)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end