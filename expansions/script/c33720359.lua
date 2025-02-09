--[[
丽贝格 精妖大法魔晶水
Yrecros Latsyrc Eth, Libeg
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")

local FLAG_MERGED_EVENT_PLAYER0 	= id
local FLAG_MERGED_EVENT_PLAYER1 	= id+100

local PLAG_DRAWN_CARDS 		= id
local PFLAG_MAXX_C_EFFECT	= id+100

function s.initial_effect(c)
	--[[If your opponent draws a card(s) during your turn (Quick Effect): You can send this card from your hand to the GY; apply these effects in sequence, based on the number of cards drawn by your
	opponent this turn up until the time this effect was activated (skip over any that do not apply).
	● 1+: Draw 1 card.
	● 3+: Each time your opponent would draw a card(s) this turn, send the top card of their Deck to the GY instead.
	● 5+: Each time you Special Summon a monster(s) this turn, your opponent immediately draws 1 card.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_DRAW,aux.TRUE,s.mergedFlag,nil,nil,nil,s.customev,nil,nil,nil,true)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_HAND)
	e1:HOPT()
	e1:SetFunctions(s.condition,aux.ToGraveSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		
		local _Draw = Duel.Draw
		
		function Duel.Draw(p,val,r)
			if Duel.IsPlayerCanDraw(p,1) and Duel.IsPlayerAffectedByEffect(p,id) and Duel.IsPlayerCanDiscardDeck(p,1) then
				Duel.DiscardDeck(p,1,REASON_EFFECT)
			end
			return _Draw(p,val,r)
		end
		
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(ep,PLAG_DRAWN_CARDS) then
		Duel.RegisterFlagEffect(ep,PLAG_DRAWN_CARDS,RESET_PHASE|PHASE_END,0,1,0)
	end
	Duel.UpdateFlagEffectLabel(ep,PLAG_DRAWN_CARDS,ev)
end

--E1
function s.mergedFlag(event,c,e,tp,eg,ep,ev,re,r,rp)
	if event==nil then
		return FLAG_MERGED_EVENT_PLAYER0,FLAG_MERGED_EVENT_PLAYER1
	else
		return id+ep*100
	end
end
function s.customev(e,tp,eg,ep,ev,re,r,rp,obj)
	local v=0
	for p=0,1 do
		if eg:IsExists(Card.HasFlagEffect,1,nil,id+p*100) then
			v=v+1+p
		end
	end
	return ({0,1,PLAYER_ALL})[v]
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (ev==1-tp or ev==PLAYER_ALL) and Duel.GetTurnPlayer()==tp
end
function s.filter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and not c:IsRace(RACE_WARRIOR)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.PlayerHasFlagEffect(1-tp,PLAG_DRAWN_CARDS) and Duel.GetFlagEffectLabel(1-tp,PLAG_DRAWN_CARDS) or 0
	if chk==0 then return ct>0 and (ct>=3 or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if ct<3 then
		e:SetCategory(CATEGORY_DRAW)
	else
		if ct>=3 then
			e:SetCategory(CATEGORY_DRAW|CATEGORY_DECKDES)
			Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
		end
		if ct>=5 then
			Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
		end
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTargetParam()
	local brk=false
	if ct>=1 then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			brk=true
		end
	end
	if ct>=3 then
		if brk then Duel.BreakEffect() end
		local e1=Effect.CreateEffect(c)
		e1:Desc(1,id)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(id)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>=5 then
		if brk then Duel.BreakEffect() end
		aux.RegisterMaxxCEffect(c,PFLAG_MAXX_C_EFFECT,tp,0,EVENT_SPSUMMON_SUCCESS,s.rmcon,s.rmopOUT,s.rmopIN,nil,RESET_PHASE|PHASE_END)
	end
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end
function s.rmopOUT(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function s.rmopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local ct=Duel.GetFlagEffect(tp,PFLAG_MAXX_C_EFFECT)
	Duel.Draw(1-tp,ct,REASON_EFFECT)
end