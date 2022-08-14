local m=31422008
local cm=_G["c"..m]
cm.name="创世万感-『贯之剑』"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(cm.fuslimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end