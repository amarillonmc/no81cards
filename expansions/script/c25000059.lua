--超甲龙 迅虹辉翼
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000059)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,2)
	local e1=rsef.I(c,{m,0},{1,m},"des",nil,LOCATION_MZONE,cm.descon,rscost.cost2(cm.fun,Card.IsDiscardable,"dish",LOCATION_HAND),rsop.target(aux.TRUE,"des",0,LOCATION_MZONE),cm.desop)
	local e2=rsef.RegisterClone(c,e1,"desc",{m,1},"tg",rsop.target(cm.desfilter2,"des",0,LOCATION_ONFIELD),"op",cm.desop2)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,2},{1,m+100},nil,nil,LOCATION_MZONE,cm.skipcon,rscost.rmxyz(1),nil,cm.skipop)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetAttackAnnouncedCount()==0 
end
function cm.fun(g,e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.desop(e,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.desfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.desop2(e,tp)
	local g=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnPlayer()~=tp or Duel.GetCurrentPhase()==PHASE_MAIN1) and rp~=tp and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_M1)
end
function cm.skipop(e,p)
	local c=e:GetHandler()
	local tp=Duel.GetTurnPlayer()
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	if tp==p then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
	local skipct=tp==p and 2 or 1
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,skipct)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,skipct)
	--if tp==p then
		--Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,skipct)
	--end
end