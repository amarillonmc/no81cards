--超巨大天体生物 迪格罗布
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000003)
function cm.initial_effect(c)
	local e1=rszg.SpSummonFun(c,m,EVENT_SUMMON_SUCCESS,cm.con)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	local e6=rsef.RegisterClone(c,e1,"code",EVENT_FLIP_SUMMON_SUCCESS)
	local e3=rszg.ToGraveFun(c)
	local e4,e5=rszg.SSSucessFun(c,m,"sp","de,dsp",rsop.target(rscf.spfilter2(Card.IsSetCard,0xaf1),"sp",LOCATION_DECK),cm.spop)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.con(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsSetCard,0xaf1),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end