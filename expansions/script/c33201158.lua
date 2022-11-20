--财宝号的水手 拉杰特
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	Mermaid_VHisc.setef(c,id)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
end
s.VHisc_Mermaid=true

--e1
function s.target(e,c)
	return c.VHisc_Mermaid
end


