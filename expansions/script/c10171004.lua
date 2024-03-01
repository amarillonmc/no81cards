--灰烬骑士 安里
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171004)
function cm.initial_effect(c)
	local e1,e2=rsds.SearchFun(c,m+10)
	local e3=rsds.ChainingFun(c,m,"sp",nil,rsop.target(rscf.spfilter2(cm.spfilter),"sp",LOCATION_DECK),cm.spop)
	e3:SetCountLimit(1,m)
end
function cm.spfilter(c)
	return not c:IsCode(m) and c:IsSetCard(0xa335)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(cm.spfilter),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end