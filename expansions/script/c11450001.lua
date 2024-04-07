--延时摄影
--2024.04.01
local tableclone=function(tab,mytab)
	local res=mytab or {}
	for i,v in pairs(tab) do res[i]=v end
	return res
end
local _Duel=tableclone(Duel)
local _Effect=tableclone(Effect)
local c=Duel.GetFieldGroup(0,0xff,0xff):GetFirst()
if c then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(function(e)
						_Duel.Hint(HINT_CARD,0,11450001)
						_Duel.Hint=function() end
						local ct=_Duel.GetTurnCount()
						for _,ph in ipairs({PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}) do _Duel.SkipPhase(0,ph,RESET_PHASE+PHASE_END,1) end
						local e1=_Effect.CreateEffect(c)
						_Effect.SetType(e1,EFFECT_TYPE_FIELD)
						_Effect.SetProperty(e1,EFFECT_FLAG_PLAYER_TARGET)
						_Effect.SetCode(e1,EFFECT_SKIP_TURN)
						_Effect.SetCondition(e1,function() return _Duel.GetTurnCount()>ct end)
						_Effect.SetTargetRange(e1,1,1)
						_Duel.RegisterEffect(e1,0)
					end)
	c:RegisterEffect(e1,true)
end
function c11450001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(function(e)
						_Duel.Hint(HINT_CARD,0,11450001)
						_Duel.Hint=function() end
						local ct=_Duel.GetTurnCount()
						for _,ph in ipairs({PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}) do _Duel.SkipPhase(0,ph,RESET_PHASE+PHASE_END,1) end
						local e1=_Effect.CreateEffect(c)
						_Effect.SetType(e1,EFFECT_TYPE_FIELD)
						_Effect.SetProperty(e1,EFFECT_FLAG_PLAYER_TARGET)
						_Effect.SetCode(e1,EFFECT_SKIP_TURN)
						_Effect.SetCondition(e1,function() return _Duel.GetTurnCount()>ct end)
						_Effect.SetTargetRange(e1,1,1)
						_Duel.RegisterEffect(e1,0)
					end)
	c:RegisterEffect(e1,true)
end