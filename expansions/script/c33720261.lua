--[[
散华·岁月的终结
End of an Eternity
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[If your opponent has added more than 7 cards to their hand this turn (without counting the ones added during the Draw Phase): It becomes this turn's End Phase.
	Also, if your opponent has added more than 13 cards to their hand (without counting the ones added during the Draw Phase) this turn, skip their next turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(s.condition,nil,aux.DummyCost,s.activate)
	c:RegisterEffect(e1)
	--[[If your opponent controls more cards than the combined number of cards in your hand and on your field, you can activate this card from your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_TO_HAND)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsDrawPhase() then return end
	for p=0,1 do
		local ct=eg:FilterCount(Card.IsControler,nil,p)
		if ct>0 then
			if not Duel.PlayerHasFlagEffect(p,id) then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,0)
			end
			Duel.UpdateFlagEffectLabel(p,id,ct)
		end
	end
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEndPhase() and Duel.PlayerHasFlagEffect(1-tp,id) and Duel.GetFlagEffectLabel(1-tp,id)>7
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,p)
	if Duel.GetFlagEffectLabel(1-tp,id)>13 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_SKIP_TURN)
		e2:SetTargetRange(0,1)
		local rct=1
		if Duel.GetTurnPlayer()==1-tp then rct=2 end
		e2:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN,rct)
		Duel.RegisterEffect(e2,tp)
	end
end

--E2
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD|LOCATION_HAND,0)
end