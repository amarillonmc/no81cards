local m=31422003
local cm=_G["c"..m]
cm.name="创世万感-『旋律之杯』"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
end