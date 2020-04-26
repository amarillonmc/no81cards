--宇宙球体 斯菲亚
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000014)
function cm.initial_effect(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop,nil,{1,m})
	local e2=rsgs.FusTypeFun(c,m,TYPE_FUSION)
	local e3=rsef.I(c,{m,1},{1,m+100},"tg",nil,LOCATION_GRAVE,nil,rscost.cost({Card.IsAbleToRemoveAsCost,"rm"},{Card.IsDiscardable,"dish",LOCATION_HAND }),rsop.target(cm.tdfilter,"td",LOCATION_DECK),cm.tdop)
end
function cm.sprcon(e,c)
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tdfilter(c)
	return c:IsLevel(1) and c:IsAbleToGrave()
end
function cm.tdop(e,tp)
	rsop.SelectToGrave(tp,cm.tdfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end