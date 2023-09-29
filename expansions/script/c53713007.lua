local m=53713007
local cm=_G["c"..m]
cm.name="爱丽丝役 ICG"
cm.alc_yaku=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYakuNew(c,m,cm.confirm,LOCATION_ONFIELD,{100,100,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT})
	SNNM.AllGlobalCheck(c)
end
function cm.confirm(c,tp)
	return Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
end
