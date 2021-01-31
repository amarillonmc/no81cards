--地中鲨 盖欧扎克
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001012)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"sp",nil,LOCATION_GRAVE,nil,rscost.cost(cm.tgfilter,"tg",LOCATION_ONFIELD),rsop.target2(cm.fun,rscf.spfilter2(),"sp"),cm.spop2)
	local e3=rsef.QO(c,nil,{m,3},{1,m+200},"dr","ptg",LOCATION_GRAVE,cm.drcon,nil,rsop.target(1,"dr"),cm.drop)
end
function cm.drcon(e,tp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_ONFIELD) and c:GetTurnID()==Duel.GetTurnCount()
end
function cm.drop(e,tp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsType(TYPE_SPELL) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local ct,og=rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE },e,tp)
	if ct>0 then
		Duel.ConfirmCards(1-tp,og)
	end
end
function cm.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown()
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.spop2(e,tp)
	local c=rscf.GetSelf(e)
	if c and rssf.SpecialSummon(c)>0 then
		rsop.SelectOC({m,2},true)
		rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
	end
end