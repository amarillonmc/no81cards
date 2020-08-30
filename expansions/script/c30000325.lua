--不灭的死骑士
if not pcall(function() require("expansions/script/c30099990") end) then require("script/c30099990") end
local m,cm=rscf.DefineCard(30000325)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),4,2)
	local e1=rsef.QO(c,nil,{m,0},{99,m},"td",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.tdfilter,"td",LOCATION_REMOVED),cm.tdop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+1},"sp","tg",LOCATION_GRAVE,nil,nil,rsop.target({rscf.spfilter2(),"sp"},rstg.list(Card.IsCanOverlay,nil,LOCATION_ONFIELD,LOCATION_ONFIELD )),cm.spop)
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function cm.tdop(e,tp)
	rsop.SelectToGrave(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil,{REASON_EFFECT+REASON_RETURN })
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c)<=0 then return end
	local tc=rscf.GetTargetCard()
	if tc and not tc:IsImmuneToEffect(e) and c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end