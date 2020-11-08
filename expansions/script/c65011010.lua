--以斯拉的督师 加利尔
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011010,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"se",{1,m},"se,th",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.I(c,"sp",{1,m+100},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(rsisr.spfilter,"sp"),rsisr.spops)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsisr.IsSet(c) and c:IsType(TYPE_CONTINUOUS)
end
function cm.thop(e,tp)
	local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc then return end
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_CHAINING,nil,nil,nil,nil,nil,cm.regop,rsreset.pend)
	e1:SetLabel(tc:GetCode())
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if (code1 and code1==code) or (code2 and code2==code) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return not rsisr.IsSet(c) and c:IsLocation(LOCATION_EXTRA)
end
