--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssp.ActivateFun(c,m,"dis,rm","dish",cm.fun,cm.op)
end
function cm.fun(e,tp,...)
	local g1=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local b1={ "dis,rm","rm",PLAYER_ALL,LOCATION_GRAVE }
	local b2={ "dis","dis",tp,LOCATION_ONFIELD }
	return g1,g2,b1,b2
end
function cm.op(op,g,e,tp)
	local c,tc=e:GetHandler(),g:GetFirst()
	if op==1 then
		local e1=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend)
	end
end
function cm.rmfilter(c)
	return aux.disfilter1(c) and c:IsAbleToRemove()
end
