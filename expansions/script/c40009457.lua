--古代龙的聚击
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009457)
function cm.initial_effect(c)
	aux.AddCodeList(c,40009452)
	local e1=rsef.ACT(c,nil,nil,nil,"se,th,td","tg",nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_GRAVE,0,5},{"opc",cm.thfilter,"th",LOCATION_DECK+LOCATION_REMOVED }),cm.act)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and not c:IsCode(m) and aux.IsCodeListed(c,40009452)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(40009452) and c:RemovePosCheck()
end
function cm.act(e,tp)
	local g=rsgf.GetTargetGroup()
	local ct,og,tc = rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_HAND) and #g>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct>0 then Duel.SortDecktop(tp,tp,ct) end
	end
end