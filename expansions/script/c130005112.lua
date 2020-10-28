--地龙唤士 法比尔
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005112,"DragonCaller")
function cm.initial_effect(c)
	local e1,e2,e3=rsdc.SynchroFun(c,m,ATTRIBUTE_EARTH,"pos",nil,rsop.target(cm.posfilter,"pos",0,LOCATION_MZONE),cm.posop,cm.limit)   
end
function cm.posfilter(c)
	return c:IsCanTurnSet() and (c:IsLevelAbove(5) or (c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation() & LOCATION_EXTRA ~= 0))
end
function cm.limit(c,rc,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.posop(e,tp)
	rsop.SelectSolve(HINTMSG_SET,tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil,cm.fun)
end
function cm.fun(g)
	local tc=g:GetFirst()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end