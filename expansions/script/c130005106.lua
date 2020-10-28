--龙唤士 琳
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005106,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},nil,"th",nil,LOCATION_MZONE+LOCATION_HAND,nil,rscost.cost(Card.IsReleasable,"res"),nil,cm.op)
	local e2=rsef.I(c,{m,1},nil,"td,th","tg",LOCATION_GRAVE,nil,nil,rstg.target({cm.thfilter2,"td",LOCATION_GRAVE,0,3,3,c},rsop.list(Card.IsAbleToHand,"th")),cm.tdop)
end
function cm.op(e,tp)
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_END,{m,0},1,nil,nil,cm.thcon,cm.thop,rsreset.pend)
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.thcon(e,tp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return #g>0
end
function cm.thop(e,tp)
	rshint.Card(m)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.thfilter2(c)
	return rsdc.IsSetM(c) and c:IsAbleToDeck() and not c:IsCode(m)
end 
function cm.tdop(e,tp)
	local tg=rsgf.GetTargetGroup()
	local c=rscf.GetSelf(e)
	if #tg>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,rsloc.de) and c then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end