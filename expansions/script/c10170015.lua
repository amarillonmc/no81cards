--星之砂 升月
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssp.ActivateFun(c,m,"dis,rm,sp,ga","lp",cm.fun,cm.op)
end
function cm.fun(e,tp,...)
	local g1=Duel.GetMatchingGroup(rscf.FilterFaceUp(Card.IsCanTurnSet),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	local b1={ "pos","pos",PLAYER_ALL,LOCATION_MZONE }
	local b2={ "rm","rm",1-tp,LOCATION_DECK+LOCATION_EXTRA }
	local cffun=function(e2,tp2)
		local cg=Duel.GetFieldGroup(tp2,0,LOCATION_DECK+LOCATION_EXTRA)
		Duel.ConfirmCards(tp,cg)
	end
	return g1,g2,b1,b2,nil,cffun
end
function cm.op(op,g,e,tp)
	if op==1 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local e1,e2=rsef.SV_LIMIT({e:GetHandler(),g:GetFirst()},"ress,resns",nil,nil,rsreset.est_pend)
	else
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
