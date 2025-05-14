--终焉兵器 亚格尼亚
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174045)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rsef.QO(c,nil,{m,0},nil,"sp,rm",nil,LOCATION_HAND+LOCATION_GRAVE,rscon.excard(aux.TRUE,LOCATION_ONFIELD,LOCATION_ONFIELD,10),rscost.regflag,cm.tg,cm.op)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_CHAIN)
end
function cm.cfilter(c,tp)
	return c:IsAbleToRemove(c,tp,POS_FACEDOWN) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and #g>0 and Duel.GetMZoneCount(tp,g,tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,0,0,0)	
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		if Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) and c and rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
			c:CompleteProcedure()
		end
	end
end
