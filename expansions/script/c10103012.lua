--界限龙 提姆福涅
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103012
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_PZONE,nil,rscost.cost(cm.resfilter,"res",LOCATION_HAND+LOCATION_MZONE),rstg.target(rsop.list(cm.pfilter,nil,LOCATION_GRAVE+LOCATION_DECK)),cm.pop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"td,dr","de,tg",nil,nil,rstg.target2(cm.fun,cm.tdfilter,"td",LOCATION_GRAVE,0,3),cm.tdop)
	cm.rs_ghostdom_dragon_effect={e1,e2}
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1)
end
function cm.tdop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.resfilter(c)
	return c:IsReleasable() and c:IsRace(RACE_DRAGON)
end
function cm.pfilter(c,e,tp)
	return c:IsSetCard(0x337) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.pop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rsof.SelectHint(tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.pfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end