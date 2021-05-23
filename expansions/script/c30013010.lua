--深土之物 塔里克丝巨蛭
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013010)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.QO(c,EVENT_CHAINING,"des",{1,m},"des",nil,LOCATION_HAND,cm.descon,rscost.cost(0,"dh"),rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	local e2 = rsef.SC_Easy(c,EVENT_FLIP,"cd",nil,cm.regop)
	local e3 = rsef.FC_Easy(c,EVENT_FLIP,nil,LOCATION_MZONE,nil,cm.regop2)
	e2:SetLabelObject(e3)
	local e4 = rsef.FC(c,EVENT_PHASE+PHASE_END,nil,1,"cd",LOCATION_MZONE,nil,cm.drop)
	e4:SetLabelObject(e3)
	local e5 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"pos",{1,m+100},"pos,tg",nil,LOCATION_GRAVE,nil,rscost.cost(1,"dh"),rsop.target({cm.pfilter,"pos",LOCATION_MZONE},{cm.tgfilter,"tg",LOCATION_GRAVE}),cm.tgop)
	local e6 = rsef.RegisterOPTurn(c,e5,cm.qcon)
	e6:SetCode(EVENT_FREE_CHAIN)
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function cm.pfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsFaceup() and c:IsCanTurnSet()
end
function cm.tgfilter(c)
	return c:IsSetCard(0x92c) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	local g,tc = rsop.SelectSolve("pos",tp,cm.pfilter,tp,LOCATION_MZONE,0,1,1,nil,{})
	if not tc or Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) <= 0 then return end
	rsop.SelectOC(nil,true)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.drop(e,tp)
	local c = e:GetHandler()
	local ct = e:GetLabelObject():GetLabel()
	if ct > 0 and not c:IsDisabled() then 
		rshint.Card(m)
		Duel.Draw(tp,ct,REASON_EFFECT) 
	end
	e:GetLabelObject():SetLabel(0)
end
function cm.regop2(e,tp)
	rshint.Card(m)
	local ct = (e:GetLabel() or 0) +1
	if not Duel.IsPlayerAffectedByEffect(tp,30013020) then 
		e:SetLabel(ct)
	else
		Duel.Draw(tp,ct,REASON_EFFECT)
		e:SetLabel(0)
	end
end
function cm.regop(e,tp)
	e:GetLabelObject():SetLabel(0)
	e:GetHandler():RegisterFlagEffect(m,rsrst.std,0,1)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.desop(e,tp)
	rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
end