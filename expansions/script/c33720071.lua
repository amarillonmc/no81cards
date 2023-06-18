--Confusione Totale - Confidenza
--Scripted by: XGlitchy30

local s,id=GetID()

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)
xpcall(function() require("expansions/script/utterconfusionlib") end,function() require("script/utterconfusionlib") end)

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(TIMING_END_PHASE,0)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		Duel.RegisterFlagEffect(0,GLITCHY_ENABLE_TEST_CHAMBER,0,0,1)
	end
end
function s.condition(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and Duel.GetLP(tp)-Duel.GetLP(1-tp)>=3000
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)-Duel.GetLP(1-tp)<3000 then return false end
	local c=e:GetHandler()
	local rct = Duel.GetTurnPlayer()~=tp and 1 or 2
	--immune
	local g1=Effect.CreateEffect(c)
	g1:SetDescription(aux.Stringid(id,3))
	g1:SetType(EFFECT_TYPE_FIELD)
	g1:SetCode(EFFECT_IMMUNE_EFFECT)
	g1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	g1:SetTargetRange(LOCATION_ONFIELD,0)
	g1:SetValue(s.efilter)
	g1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(g1,tp)
	local g2=Effect.CreateEffect(c)
	g2:SetDescription(aux.Stringid(id,4))
	g2:SetType(EFFECT_TYPE_FIELD)
	g2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	g2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	g2:SetTargetRange(LOCATION_ONFIELD,0)
	g2:SetValue(1)
	g2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(g2,tp)
	--change targeting player
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.changetg)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	--opponent chooses search targers
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_UTTER_CONFUSION_CONFIDENCE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e2,tp)
	--opponent chooses attack targets
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,7))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e3,tp)
end
function s.efilter(e,te,c)
	return te:GetOwner()~=c
end
function s.changetg(e,re,rp)
	return re:IsActivated() and rp and rp==e:GetOwnerPlayer()
end