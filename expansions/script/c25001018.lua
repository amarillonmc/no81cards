--自然控制机器 深绿
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001018)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(nil,"disd",LOCATION_DECK,0,1,3),cm.sptg,cm.spop)
	local e3=rsef.QO(c,nil,{m,1},1,"pos",nil,LOCATION_MZONE,cm.tscon,nil,rsop.target(cm.tsfilter,"pos",0,LOCATION_ONFIELD),cm.tsop)
	local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+100},nil,"de",cm.plcon,nil,nil,cm.plop)
	local e5=rsef.STO(c,EVENT_LEAVE_FIELD,{m,3},{1,m+200},"se,th","de",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thfilter(c)
	return c:IsCode(m-1,m-2) and c:IsAbleToHand()
end 
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.plcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.thcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function cm.plop(e,tp)
	local c=rscf.GetSelf(e)
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.tscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.tsfilter(c)
	local chain=Duel.GetCurrentChain()
	if chain>1 then
		for i=1,chain do 
			local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==c then return false end
		end
	end
	return not c:IsComplexType(TYPE_PENDULUM+TYPE_SPELL) and c:IsCanTurnSet()
end
function cm.tsop(e,tp)
	rsop.SelectSolve(HINTMSG_SET,tp,cm.tsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),cm.tsfun,e,tp)
end
function cm.tsfun(g,e,tp)
	local ct=Duel.ChangePosition(g,POS_FACEDOWN)
	if g:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	return ct
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x1021,1400,1800,3,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x1021,1400,1800,3,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL+TYPE_TUNER)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)
end