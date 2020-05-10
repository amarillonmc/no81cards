--巨兽 佐利姆
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000002)
function cm.initial_effect(c)
	local e1=rszg.SpSummonFun(c,m,EVENT_TO_HAND,cm.con)
	local e3=rszg.ToGraveFun(c)
	local e4,e5=rszg.SSSucessFun(c,m,"se,th","de,dsp",rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.con(e,tp,eg)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end