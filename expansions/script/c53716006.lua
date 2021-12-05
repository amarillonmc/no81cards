local m=53716006
local cm=_G["c"..m]
cm.name="断片折光 幻想愚间"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,1400,1500,RACE_FIEND,ATTRIBUTE_EARTH)
end
function cm.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x20004)==0x20004 and not c:IsCode(m)
end
function SNNM.FanippetTrapSPCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
