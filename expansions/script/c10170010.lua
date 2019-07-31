--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170010
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,1),1)
	local e1=rssp.LinkCopyFun(c)
	local e2=rssp.ChangeOperationFun2(c,m,false,cm.con,cm.op)
end
function cm.con(e,tp)
	return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.op(e,tp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end
