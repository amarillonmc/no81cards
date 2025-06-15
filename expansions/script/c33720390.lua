--[[
科技对狠活
TECH Versus POWER
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[When this card is activated: Your opponent chooses either "Tech" or "Power", or both, and this card gains the following effect(s) based on what they chose.
	● Tech: Neither player can activate card effects in response to their opponent's card effects during their opponent's turn. 
	● Power: During the Battle Phase, the turn player's opponent cannot activate card effects.
	Also, if your opponent chooses both "Tech" and "Power", both players draw 2 cards.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b3=Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2)
	local opt=aux.Option(1-tp,id,1,true,true,b3)+1
	if opt&1==1 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_SZONE)
		e1:SetOperation(s.chainop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if opt&2==2 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(1,0)
		e2:SetCondition(s.limcon0)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetTargetRange(0,1)
		e3:SetCondition(s.limcon1)
		c:RegisterEffect(e3)
	end
	if opt==3 then
		for p in aux.TurnPlayers() do
			Duel.Draw(p,2,REASON_EFFECT)
		end
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsTurnPlayer(ep) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==Duel.GetTurnPlayer()
end
function s.limcon0(e)
	return Duel.IsBattlePhase(1-e:GetHandlerPlayer())
end
function s.limcon1(e)
	return Duel.IsBattlePhase(e:GetHandlerPlayer())
end