--破坏死光
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174075)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"dish,des",nil,nil,nil,rsop.target({1,"dh" },{Card.IsAbleToGrave,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c }),cm.act)
end
function cm.act(e,tp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil,REASON_EFFECT)>0 then
		rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),{})
	end
	local c=rscf.GetFaceUpSelf(e)
	if c and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
