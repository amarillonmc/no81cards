--沉默骑士 霍拉斯
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171014)
function cm.initial_effect(c)
	local e1=rsds.TributeFun(c,m,"sp","tg",rstg.target(rscf.spfilter2(cm.spfilter),"sp",rsloc.gr),cm.spop,true)
	local e2=rsds.SpExtraFun(c,m,m-10,m-3)  
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa335)
end
function cm.spop(e,tp)
	local c=rscf.GetTargetCard()
	if c then rssf.SpecialSummon(c) end
end