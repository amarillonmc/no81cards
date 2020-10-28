--翠龙唤士 菲莉丝
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005110,"DragonCaller")
function cm.initial_effect(c)
	local e1,e2,e3=rsdc.SynchroFun(c,m,ATTRIBUTE_WIND,"des",nil,rsop.target(cm.desfilter,"des",0,LOCATION_ONFIELD),cm.desop,cm.limit)   
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.limit(c,rc)
	return rc:IsLocation(rsloc.hg)
end
function cm.desop(e,tp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end