--狐之未眠
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(170001)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,{1,m,2},"sp",nil,nil,cm.cost,rsop.target2(cm.fun,cm.spfilter,"sp",LOCATION_DECK,0,cm.ct),cm.act)
	local e2 = rsef.SV_ACTIVATE_IMMEDIATELY(c,"hand",cm.acon)
end
function cm.acon(e)
	local tp = e:GetHandlerPlayer()
	return Duel.GetCurrentPhase() == PHASE_MAIN1 and Duel.GetTurnPlayer() == tp  and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) > 0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) == 0 and not Duel.CheckPhaseActivity()
end
function cm.cfilter(c)
	return not c:IsPublic() and c:IsRace(RACE_BEAST)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsOnField() or Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g = rsop.SelectSolve(HINTMSG_CONFIRM,tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,{})
		if #g > 0 then
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.fun(g,e,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.ct(e,tp)
	local ct = math.abs(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) - Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	if ct > 0 and Duel.GetLocationCount(tp,LOCATION_MZONE) >= ct then return ct 
	else return 0
	end
end
function cm.spfilter(c,e,tp)
	return rscf.spfilter()(c,e,tp) and c:IsRace(RACE_BEAST) and c:IsLevel(2)
end
function cm.act(e,tp)
	local ct = math.abs(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) - Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct > 0 and ft >= ct then 
		rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,{},e,tp)
	end
	local e1 = rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.tg,{1,0},nil,rsreset.pend)
end
function cm.tg(e,c)
	return not c:IsRace(RACE_BEAST)
end