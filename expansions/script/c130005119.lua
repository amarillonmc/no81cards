--堕龙的唤士
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005119,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,nil,"pos,se,th",nil,nil,rscost.cost(cm.rmfilter,"rm",rsloc.hg),rsop.target2(cm.fun,cm.posfilter,"pos",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.act)
end
function cm.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and rsdc.IsSetM(c)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cm.posfilter(c)
	local chain=Duel.GetCurrentChain()
	if chain>1 then
		for i=1,chain do 
			local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==c then return false end
		end
	end
	return not c:IsComplexType(TYPE_PENDULUM+TYPE_SPELL) and c:IsCanTurnSet()
end
function cm.act(e,tp)
	if rsop.SelectSolve(HINTMSG_SET,tp,cm.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),cm.posfun,e,tp)>0 then
		rsop.SelectOC({m,0},true)
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.thfilter(c)
	return c:IsCode(130005105) and c:IsAbleToHand()
end
function cm.posfun(g,e,tp)
	local ct=Duel.ChangePosition(g,POS_FACEDOWN)
	if g:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	return ct
end 