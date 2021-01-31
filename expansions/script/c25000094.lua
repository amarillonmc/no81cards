--天球之月
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000094)
function cm.initial_effect(c)   
	local e1=rsef.ACT(c,nil,nil,{1,m},nil,nil,nil,nil,cm.tg,cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},nil,nil,LOCATION_GRAVE,rscon.excard2(cm.exfilter,LOCATION_ONFIELD),aux.bfgcost,nil,cm.limitop)
end
function cm.limitop(e,tp)
	local c=e:GetHandler()
	local e1,e2,e3,e4=rsef.FV_LIMIT_PLAYER({c,tp},"rm,res,th",nil,aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE),{1,1},nil,{rsreset.pend,2})
end
function cm.exfilter(c)
	return c:IsComplexType(TYPE_SPELL,true,TYPE_CONTINUOUS,TYPE_FIELD)
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,rsloc.gr+LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1})
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,rsloc.gr+LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,rsloc.hg)	 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,rsloc.hg) 
	end
	e:SetLabel(op)
end
function cm.thfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(rscf.fufilter(Card.IsRace,RACE_MACHINE),tp,rsloc.mg,0,nil)
	if g:GetClassCount(Card.GetCode)<4 and c:IsLocation(LOCATION_DECK) then return false end
	return (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsAbleToHand() and c:IsComplexType(TYPE_SPELL,true,TYPE_CONTINUOUS,TYPE_FIELD)
end
function cm.rmfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IsExistingMatchingCard(rscf.spfilter(Card.IsRace,RACE_MACHINE),tp,rsloc.hg,0,1,nil,e,tp)
end
function cm.act(e,tp)
	local op=e:GetLabel()
	if op==1 then
		rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.gr+LOCATION_DECK,0,1,1,nil,{},e,tp)
	elseif op==2 then
		if rsop.SelectRemove(tp,cm.rmfilter,tp,rsloc.hg,0,1,1,nil,{},e,tp)>0 then
			rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter(Card.IsRace,RACE_MACHINE)),tp,rsloc.hg,0,1,1,nil,{},e,tp)
		end
	end
end