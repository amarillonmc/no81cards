--唤士的救赎
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005117,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"se,th,sp",nil,nil,rscost.cost(cm.dishfilter,"dish",LOCATION_HAND),cm.tg,cm.act)
end
function cm.dishfilter(c)
	return c:IsDiscardable() and rsdc.IsSet(c)
end
function cm.spfilter(c,e,tp)
	return rscf.RemovePosCheck(c) and rscf.spfilter2(rsdc.IsSet)(c,e,tp) and Duel.IsExistingMatchingCard(cm.thfilter,tp,rsloc.dg,0,1,c)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(130005101)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,rsloc.gr,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1})
	e:SetLabel(op)
	if op==1 then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)	
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	else	
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,rsloc.gr)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,rsloc.dg)
	end
end
function cm.act(e,tp)
	local op=e:GetLabel()
	if op==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		if rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.gr,0,1,1,nil,{},e,tp)>0 then
			rsop.SelectOC(nil,true)
			rsop.SelectToHand(tp,cm.thfilter,tp,rsloc.dg,0,1,1,nil,{})
		end
	end
end
