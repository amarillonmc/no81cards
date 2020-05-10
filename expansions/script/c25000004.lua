--超巨大单极子生物 莫基安
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000004)
function cm.initial_effect(c)
	local e1=rszg.SpSummonFun(c,m,EVENT_CHAIN_SOLVING,cm.con)
	local e2=rszg.ToGraveFun(c)
	local e3,e4=rszg.SSSucessFun(c,m,"sp","de,dsp",rsop.target(rscf.spfilter2(cm.spfilter),"sp",LOCATION_REMOVED),cm.spop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xaf1) and c:IsFaceup()
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(cm.spfilter),tp,LOCATION_REMOVED,0,1,1,nil,{},e,tp)
end