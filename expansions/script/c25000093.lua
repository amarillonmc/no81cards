--钢铁的宇宙•有机生命抹杀计划
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000093)
function cm.initial_effect(c)   
	local e1=rsef.ACT(c)
	local e2=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_SZONE,nil,nil,rsop.target(rscf.spfilter2(Card.IsRace,RACE_MACHINE),"sp",LOCATION_DECK),cm.spop)
	local e3=rsef.FV_ADD(c,"race",RACE_MACHINE)
	local e4=rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.tg,{0,1},cm.con)
	local e5=rsef.FV_LIMIT_PLAYER(c,"act",cm.val,nil,{0,1},cm.con)  
	local e6=rsef.I(c,{m,6},{1,m+100},"th,ga",nil,LOCATION_GRAVE,nil,rscost.cost(cm.tgfilter,"tg",LOCATION_ONFIELD),rsop.target(cm.thfilter,nil),cm.thop)
end
function cm.tgfilter(c)
	if not c:IsAbleToGraveAsCost() then return false end
	return (c:IsRace(RACE_MACHINE) and c:IsFaceup()) or c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thfilter(c,e,tp)
	return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.thop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if not b1 and not b2 then return end
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function cm.spop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsRace,RACE_MACHINE),tp,LOCATION_DECK,0,1,1,nil,{0,tp,tp,false,false,POS_FACEUP,nil,{"dis,dise"}},e,tp)
end
function cm.tg(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttackAbove(2500)
end
function cm.con(e)
	local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=6
end
function cm.val(e,re)
	return not re:GetHandler():IsRace(RACE_MACHINE)
end