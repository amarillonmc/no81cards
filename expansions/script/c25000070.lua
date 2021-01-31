--宇宙重置机器 葛洛卡•车
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000070)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des,dam",nil,LOCATION_MZONE,nil,rscost.cost(1,"dish"),rsop.target(aux.TRUE,"des",0,LOCATION_HAND),cm.desop)
	local e2=rsef.SC(c,EVENT_BATTLE_START)
	e2:SetOperation(cm.desop2)
	local e3=rsef.I(c,{m,1},{1,m+100},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(cm.linkfilter,"sp",LOCATION_EXTRA),cm.linkop)
end
function cm.desop(e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		local dg=g:RandomSelect(tp,1)
		if Duel.Destroy(dg,REASON_EFFECT)>0 and dg:GetFirst():IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function cm.desop2(e,tp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsRelateToBattle() then return end
	rshint.Card(m)
	Duel.Destroy(bc,REASON_EFFECT)
end
function cm.getmat(c,e,tp,bool)
	local g1=rscf.GetLinkMaterials2(tp,nil,c)
	local tc=e:GetHandler()
	if tc:IsAbleToExtraAsCost() and tc:IsCanBeLinkMaterial(c) and not cm.check then
		g1:AddCard(tc)
	end
	return g1
end
function cm.linkfilter(c,e,tp)
	local matg=cm.getmat(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(matg)
end
function cm.linkop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then 
		cm.check=true
	end
	rshint.Select(tp,"sp")
	local lc=Duel.SelectMatchingCard(tp,cm.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local matg=cm.getmat(lc,e,tp)
	rssf.LinkMaterialAction=cm.fun(c)
	Duel.LinkSummon(tp,lc,matg)
	cm.check=false
end
function cm.fun(c)
	return function(g,lc)
		if g:IsContains(c) then
			Duel.SendtoDeck(c,nil,2,REASON_COST+REASON_MATERIAL+REASON_LINK)
			g:RemoveCard(c)
		end
		Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_LINK)
	end
end