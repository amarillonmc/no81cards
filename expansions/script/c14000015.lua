--时穿剑·玄冥剑
local m=14000015
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--chrbeffects
	chrb.dire(c)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.atkfilter)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
end
function cm.atkfilter(e,c)
	return chrb.CHRB(c)
end