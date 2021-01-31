--巴萨库系统启动
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000075)
function cm.initial_effect(c)   
	aux.AddCodeList(c,25000073)
	local e1=rsef.ACT(c,nil,nil,{1,m},"se,th",nil,nil,nil,rsop.target(cm.thfilter0,"th",LOCATION_DECK),cm.act)
	local e2=rsef.QO(c,nil,{m,0},{1,m+100},"sp",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter,"tg",LOCATION_HAND+LOCATION_ONFIELD),rsop.target(rscf.spfilter(Card.IsRace,RACE_MACHINE),"sp",LOCATION_GRAVE),cm.spop)
	local e3=rsef.QO(c,nil,{m,1},{1,m+100},"se,th",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter2,"tg",LOCATION_HAND+LOCATION_ONFIELD),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e4=rsef.I(c,{m,2},{1,m+200},"th,ga",nil,LOCATION_GRAVE,rscon.excard2(cm.rtcfilter,LOCATION_ONFIELD),nil,rsop.target(cm.rtfilter,nil),cm.rtop)
end
function cm.thfilter0(c)
	return c:IsAbleToHand() and c:IsCode(m+1)
end 
function cm.act(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectToHand(tp,cm.thfilter0,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.cfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end 
function cm.spop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(Card.IsRace,RACE_MACHINE)),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m-1)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.rtcfilter(c,e,tp)
	return c:IsCode(25000073) or aux.IsCodeListed(c,25000073)
end
function cm.rtfilter(c,e,tp)
	return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.rtop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if not b1 and not b2 then return end
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,3})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end