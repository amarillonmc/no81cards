--宇宙来的机械岛
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001003)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"se,th,td",nil,nil,nil,rsop.target({cm.tdfilter,cm.gcheck},"td",rsloc.hmg+LOCATION_REMOVED,0,2),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},"se,th,sp",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE),rsop.target2(cm.fun,cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e3=rsef.I(c,{m,2},{1,m+100},"tg",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE),rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e4=rsef.I(c,{m,4},{1,m+200},"th",nil,LOCATION_REMOVED,nil,rscost.cost(Card.IsAbleToHandAsCost,"th",LOCATION_ONFIELD),rsop.target(cm.thcfilter,"th"),cm.thcop)
end
function cm.thcfilter(c,e,tp)
	return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.thcop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local b1=tc:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,4})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.cfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsRace(RACE_MACHINE))
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m+2) and (c:IsAbleToHand() or rscf.spfilter2()(c,e,tp))
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,cm.solvefun,e,tp)
end
function cm.solvefun(g,e,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToHand()
	local b2=rscf.spfilter2()(tc,e,tp)
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,3})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	return true
end
function cm.tdfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsAbleToDeck() 
end
function cm.gcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,g)
end
function cm.thfilter(c,g)
	return c:IsAbleToHand() and c:IsRace(RACE_MACHINE) and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.act(e,tp)
	if not rscf.GetSelf(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,rsloc.hmg+LOCATION_REMOVED,0,nil)
	if not g:CheckSubGroup(cm.gcheck,2,2,e,tp) then return end
	rshint.Select(tp,"td")
	local tg=g:SelectSubGroup(tp,cm.gcheck,false,2,2,e,tp)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},g)
	end
end