local m=31430002
local cm=_G["c"..m]
cm.name="机械本我-战斗姿态"
function cm.initial_effect(c)
	c:EnableReviveLimit()
end
