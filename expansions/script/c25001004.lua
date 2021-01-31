--钢铁的假面 哥布纽•基加
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001004)
function cm.initial_effect(c)
	local e1=rsef.STO(c,EVENT_TO_GRAVE,{m,0},{1,m},"sp","de,dsp",cm.spcon,nil,rsop.target(rscf.spfilter2(Card.IsCode,m),"sp",LOCATION_DECK),cm.spop)
	local e2=rsef.I(c,{m,1},{1,m+100},"se,th",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thfilter(c,e,tp)
	return c:IsCode(m-1) and (c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.thop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,cm.thfun,e,tp)
end
function cm.thfun(g,e,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	return true
end
function cm.spcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.spop(e,tp)
	local sg=Duel.GetMatchingGroup(rscf.spfilter2(Card.IsCode,m),tp,LOCATION_DECK,0,nil,e,tp)
	local maxct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),#sg)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then maxct=1 end
	rsgf.SelectSpecialSummon(sg,tp,aux.TRUE,maxct,maxct,nil,{})
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.tg,{1,0},nil,rsreset.pend)
end
function cm.tg(e,c)
	return not c:IsRace(RACE_MACHINE)
end