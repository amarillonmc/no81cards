--虎魂
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174076)
function cm.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	rscf.SetSummonCondition(c,true,aux.FALSE)
	local e1=rsef.STF(c,EVENT_SUMMON_SUCCESS,{m,0},nil,"se,th","de,dsp",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK+LOCATION_GRAVE),cm.thop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_FLIP)
	local e3=rsef.SV_LIMIT(c,"atk",nil,cm.cacon)
end
function cm.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand() and c:IsLevel(4)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.cacon(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end