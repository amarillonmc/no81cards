--雪原的前哨员
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174063)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},nil,nil,nil,LOCATION_HAND,cm.con,rscost.cost(cm.cfilter,{nil,cm.fun}),rsop.target(cm.cffitler,nil,0,LOCATION_HAND+LOCATION_ONFIELD),cm.op,{ 0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END })
end
function cm.con(e,tp)
	local ph = Duel.GetCurrentPhase()
	return (ph == PHASE_MAIN1 or ph == PHASE_MAIN2) and Duel.GetTurnPlayer() ~= tp
end
function cm.cfilter(c)
	return not c:IsPublic()
end
function cm.fun(g,e,tp)
	local c=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(rsreset.est_pend)
	c:RegisterEffect(e1)
end
function cm.cffilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND) 
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rshint.Select(tp,HINTMSG_CONFIRM)
	local tg=Duel.SelectMatchingCard(tp,cm.cffilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	Duel.ConfirmCards(tp,tg)
	local tc=tg:GetFirst()
	local code,tct=tc:GetCode(),Duel.GetTurnCount()
	local e1=rsef.FV_LIMIT_PLAYER({c,tp},"act",cm.limitval(code),nil,{0,1},cm.limitcon(tct),{rsreset.est_pend,2})
	local e2,e3=rsef.FV_LIMIT_PLAYER({c,tp},"sum,sp",nil,cm.limittg(code),{0,1},cm.limitcon(tct),{rsreset.est_pend,2})
end
function cm.limitval(code)
	return function(e,re)
		return re:GetHandler():IsCode(code)
	end
end
function cm.limittg(code)
	return function(e,c)
		return c:IsCode(code)
	end
end
function cm.limitcon(tct)
	return function(e,tp)
		return Duel.GetTurnCount()~=tct
	end
end