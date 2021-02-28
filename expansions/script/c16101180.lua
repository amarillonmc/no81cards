--MIGHTY-PORO
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16101180,"PORO")
function cm.initial_effect(c)
   --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function cm.indtg(e,c)
	return rk.check(c,"PORO") and c~=e:GetHandler()
end