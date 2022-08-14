local m=31422006
local cm=_G["c"..m]
cm.name="创世万感-『苍空之琴』"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end