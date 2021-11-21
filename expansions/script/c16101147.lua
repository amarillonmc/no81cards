local m=16101147
local cm=_G["c"..m]
function cm.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lkcheck,2,2)
end
function cm.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
