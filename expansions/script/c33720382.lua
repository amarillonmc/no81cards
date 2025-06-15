--[[
【背景音台】晦空士景 ～三时三十三分～
Sepialife in 3:33
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_soundstage.lua")
function s.initial_effect(c)
	--When this card is activated from your hand: It becomes the End Phase.
	local e0=c:Activation(nil,nil,nil,nil,s.epop)
	aux.AddSoundStageProc(c,e0,id,3,0)
	--[[During the End Phase: Apply the following effects in sequence.
	● If the turn player has not Normal Summoned this turn, that player can draw 1 card, and if they do, they discard 1 card.
	● If the turn player has not Special Summoned this turn, that player can draw 1 card, and if they do, they send the top card of their Deck to the GY.
	● If the turn player has not declared an attack this turn, that player can Special Summon 1 monster from their hand or GY.
	● If the turn player has not activated other card effects this turn, all damage they would take until the start of their next turn becomes 0.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORY_DRAW|CATEGORY_HANDES|CATEGORY_DECKDES|CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:OPT()
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.counterfilter(c))
end
function s.counterfilter(c)
	return	function(e,p,cid)
				return e:GetHandler()==c
			end
end

--E0
function s.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		local p=Duel.GetTurnPlayer()
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,p)
	end
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=Duel.GetTurnPlayer()
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,p,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,p,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,p,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,p,LOCATION_HAND|LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local brk=false
	if Duel.GetActivityCount(p,ACTIVITY_SUMMON)==0 and Duel.IsPlayerCanDraw(p,1) and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		if Duel.Draw(p,1,REASON_EFFECT)>0 then
			brk=true
			Duel.ShuffleHand(p)
			Duel.DiscardHand(p,aux.TRUE,1,1,REASON_EFFECT|REASON_DISCARD)
		end
	end
	if Duel.GetActivityCount(p,ACTIVITY_SPSUMMON)==0 and Duel.IsPlayerCanDraw(p,1) and Duel.IsPlayerCanDiscardDeck(p,1) and Duel.GetDeckCount(p)>=2 and Duel.SelectYesNo(p,aux.Stringid(id,3)) then
		if brk then
			Duel.BreakEffect()
			brk=false
		end
		if Duel.Draw(p,1,REASON_EFFECT)>0 then
			brk=true
			Duel.DiscardDeck(p,1,REASON_EFFECT)
		end
	end
	if Duel.GetActivityCount(p,ACTIVITY_ATTACK)==0 and Duel.GetMZoneCount(p,nil,p)>0
		and Duel.IsExists(false,aux.Necro(Card.IsCanBeSpecialSummoned),p,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) and Duel.SelectYesNo(p,aux.Stringid(id,4)) then
		if brk then
			Duel.BreakEffect()
			brk=false
		end
		local tc=Duel.Select(HINTMSG_SPSUMMON,false,p,aux.Necro(Card.IsCanBeSpecialSummoned),p,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)>0 then
			brk=true
		end
	end
	if Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 then
		if brk then
			Duel.BreakEffect()
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:Desc(5,id)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,p)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,p)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START|PHASE_DRAW)
		e3:OPT()
		e3:SetLabelObject(e2)
		e3:SetCondition(aux.TurnPlayerCond(0))
		e3:SetOperation(s.reset)
		Duel.RegisterEffect(e3,p)
	end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local e2=e:GetLabelObject()
	local e1=e2 and e2:GetLabelObject() or nil
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	e:Reset()
end