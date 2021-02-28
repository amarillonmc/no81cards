--机械加工·起
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009425)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"tg,sp",nil,nil,nil,rsop.target2(rstg.opinfo("sp",0,0,LOCATION_DECK),cm.tgfilter,"tg",LOCATION_DECK),cm.act)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_INSECT)
end
function cm.act(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_NORMAL) then
		rsop.SelectOC("sp",true)
		rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsSetCard,0x5f1d),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
	end
end
