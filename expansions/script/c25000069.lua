--宇宙重置机器 葛洛卡•卒
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000069)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des,sp","tg",LOCATION_MZONE,nil,nil,rstg.target(aux.TRUE,"des",LOCATION_MZONE,LOCATION_MZONE),cm.desop)
	local e3=rsef.I(c,{m,1},{1,m+100},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(cm.linkfilter,"sp",LOCATION_EXTRA),cm.linkop)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		rsop.SelectOC({m,2},true)
		rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP,nil,{"mat",Group.CreateGroup(),"cp"}},e,tp)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
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