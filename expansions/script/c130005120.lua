--唤士的决断
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005120,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"tg,se,th",nil,nil,nil,rsop.target2(cm.fun,cm.tgfilter,"tg",LOCATION_DECK),cm.act)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and rsdc.IsSetM(c) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,c,c:GetLevel())
end
function cm.thfilter(c,lv)
	return c:IsAbleToHand() and rsdc.IsSetM(c) and not c:IsLevel(lv)
end
function cm.act(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		rsop.SelectOC(nil,true)
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},tc:GetLevel())
	end
end