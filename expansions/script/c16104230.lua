--终末之歌
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rscf.DefineCard(16104230,"CHURCH_KNIGHT")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"tg",nil,nil,cm.cost,rsop.target(cm.tgfilter,"tg",LOCATION_MZONE,0,true),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},"td,dr",nil,LOCATION_GRAVE,nil,nil,rsop.target({Card.IsAbleToDeck,"td"},{cm.tdfilter,"td",LOCATION_GRAVE+LOCATION_REMOVED }),cm.drop)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsSetCard(0x3ccd)
end
function cm.act(e,tp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local atk=Duel.GetOperatedGroup():GetSum(Card.GetBaseAttack)
		for p=0,1 do
			Duel.SetLP(p,math.max(0,Duel.GetLP(p)-atk))
		end
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0xccd) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.drop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsop.SelectSolve(HINTMSG_TODECK,tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,2,c,cm.solvefun,c,tp)
end
function cm.solvefun(g,c,tp)
	g:AddCard(c)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,rsloc.de) then
		if Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	return true 
end