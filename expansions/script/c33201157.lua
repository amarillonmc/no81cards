--财宝号的船长 布彻
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	Mermaid_VHisc.setef(c,id)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(s.atktg)
	e1:SetValue(800)
	c:RegisterEffect(e1)
end
s.VHisc_Mermaid=true

--atk up
function s.atktg(e,c)
	return c.VHisc_Mermaid and e:GetHandler()~=c
end

