--以斯拉的后卫 爱恩多姆
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011012,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"tg",{1,m},"tg,sp",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target2(cm.fun,cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e2=rsef.I(c,"sp",{1,m+100},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(rsisr.spfilter,"sp"),rsisr.spops)  
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsisr.IsSet(c)
end 
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,rsloc.hd)
end
function cm.tgop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_GRAVE) and rscon.excard2(rsisr.IsSet,0,LOCATION_MZONE)(e,tp) then
		rsop.SelectOC("sp",true)
		rsop.SelectSpecialSummon(tp,rscf.spfilter2(rsisr.IsSet),tp,rsloc.hd,0,1,1,nil,{},e,tp)
	end
end
function cm.splimit(e,c)
	return not rsisr.IsSet(c)
end