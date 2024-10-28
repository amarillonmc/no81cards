--汇聚之地·天龙座
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetCondition(s.con)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(2,id)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id+1)
	e3:SetCondition(s.con2)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(2,id+o)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3) 
end
function s.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 )
end
function s.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp
end