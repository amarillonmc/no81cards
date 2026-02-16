local m=15006200
local cm=_G["c"..m]
cm.name="星晶龙壳"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006201)
	c:EnableReviveLimit()
end
