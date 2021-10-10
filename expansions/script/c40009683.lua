--天轮圣龙 涅槃·轮回
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009683)
function cm.initial_effect(c)
	local e1 = rsef.SV_Card(c,"code",40009579,"sr",rsloc.hg)
	local e2 = rsef.QO_NegateEffect(c,nil,{1,m},LOCATION_MZONE,
		rscon.dis("m"),rscost.cost(cm.resfilter,"res"),"sp",nil,
		rsop.target({cm.spfilter,cm.gcheck},"sp",LOCATION_GRAVE,0,1,3),
		cm.exop)
	local e3 = rsef.FTF(c,EVENT_PHASE+PHASE_STANDBY,"td",{1,m+100},
		"td,sp",nil,LOCATION_GRAVE,cm.tdcon,nil,
		rsop.target({Card.IsAbleToDeck,"td"},
		{cm.spfilter2,"sp",LOCATION_DECK }),cm.tdop)
end
function cm.resfilter(c,e,tp)
	return c:IsReleasable() and c:IsSummonType(SUMMON_TYPE_RITUAL) 
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6f1b,0x8f1b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function cm.gcheck(g,e,tp)
	return g:GetSum(Card.GetLevel) == 9 and Duel.GetMZoneCount(tp,e:GetHandler(),tp) >= #g
end
function cm.gcheck2(g,e,tp)
	return g:GetSum(Card.GetLevel) == 9 and Duel.GetLocationCount(tp,LOCATION_MZONE) >= #g
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ~= 1 then return end
	rsop.SelectOperate("sp",tp,{aux.NecroValleyFilter(cm.spfilter),cm.gcheck2},tp,LOCATION_GRAVE,0,1,3,nil,{},e,tp)
end
function cm.tdcon(e,tp)
	local c = e:GetHandler()
	return c:GetTurnID() == Duel.GetTurnCount() - 1 and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(40009579) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
end
function cm.tdop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or Duel.SendtoDeck(c,nil,1,REASON_EFFECT) <= 0 or not c:IsLocation(LOCATION_DECK) then return end
	rsop.SelectOperate("sp",tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,{SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP,nil,{"cp","mat",Group.CreateGroup()}},e,tp)
end