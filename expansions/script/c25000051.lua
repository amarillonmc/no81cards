--未知之手
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000051)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp",nil,nil,rscost.cost(cm.cfilter,"rm_d",LOCATION_HAND+LOCATION_MZONE),rsop.target(rssb.ssfilter(),"sp",LOCATION_REMOVED),cm.spop)
	local e2=rsef.I(c,{m,0},nil,"dr,rm",nil,LOCATION_GRAVE,aux.exccon,rscost.cost(cm.cfilter2,"td",LOCATION_GRAVE,0,1,3),rsop.target({nil,"dr",1},{rssb.rmfilter,"rm"}),cm.drop)
end
function cm.cfilter(c)
	return rssb.rmcfilter(c) and Duel.GetMZoneCount(tp,c,tp)>0 and rssb.IsSetM(c)
end
function cm.spop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	rsop.SelectSpecialSummon(tp,rssb.ssfilter(true),tp,LOCATION_REMOVED,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP},e,tp)
end
function cm.cfilter2(c)
	return c:IsAbleToDeckOrExtraAsCost() and rssb.IsSetM(c)
end
function cm.drop(e,tp)
	local c=aux.ExceptThisCard(e)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and c then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end 
end