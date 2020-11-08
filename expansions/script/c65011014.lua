--以斯拉的海龙 萨尔
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011014,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"tg",{1,m},"tg,sp",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target2(cm.fun,cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e2=rsef.I(c,"sp",{1,m+100},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(cm.spfilter,"sp"),cm.spop)	  
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsisr.IsSet(c)
end 
function cm.fun(g,e,tp)
	local c=e:GetHandler()
	if c:IsLocation(rsloc.gr) and c:IsReason(REASON_COST+REASON_DISCARD) then
		Duel.SetTargetCard(c)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,0,0,0)
	end
end
function cm.tgop(e,tp)
	local c=e:GetHandler()
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_GRAVE) and rscon.excard2(rsisr.IsSet,0,LOCATION_MZONE)(e,tp) and c:IsRelateToEffect(e) and rscf.spfilter2()(c,e,tp) and rsop.SelectYesNo(tp,"sp") then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsisr.drawlimit(e,tp)
	local c=rscf.GetSelf(e)
	if c and rsisr.spop(e,tp,POS_FACEUP_DEFENSE)>0 then
		rsop.SelectOC("sp",true)
		rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(rsisr.IsSet)),tp,rsloc.dg,0,1,1,nil,{},e,tp)
	end
end
