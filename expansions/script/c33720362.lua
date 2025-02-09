--[[
动物朋友 马耳他虎
Anifriends Maltese Tiger
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local FLAG_DELAYED_EVENT		= id+100
local FLAG_SIMULT_CHECK			= id+200
local FLAG_SIMULT_EXCLUDE		= id+300

local PFLAG_SENT_CARD_COUNTER	= id

Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,CARD_MEMORIES_OF_THE_SANDSTAR)
	--[[After this card is Ritual Summoned with "Memories of the Sandstar", it is unaffected by your opponent's card effects until the end of your opponent's next turn, also it cannot be destroyed by
	battle.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--[[If a card(s) is sent to your opponent's GY, and 5 or more total cards have been sent to your opponent's GY this turn: Activate this effect, also your opponent cannot activate card effects from
	their GY until after this effects resolves; your opponent chooses 1 of these effects for you to apply.
	● Add that sent card(s) to your hand.
	● Your opponent shuffles that sent card(s) into the Deck, and if they do, this card gains 200 ATK for each.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_TO_GRAVE,s.evfilter,FLAG_DELAYED_EVENT,LOCATION_MZONE,nil,LOCATION_MZONE,nil,FLAG_SIMULT_CHECK,true)
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_TODECK|CATEGORY_ATKCHANGE|CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_TO_GRAVE)
		ge:SetOperation(s.updateCounter)
		Duel.RegisterEffect(ge,0)
	end
end
function s.updateCounter(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(Card.IsControler,nil,p)
		if ct>0 then
			Duel.UpdateFlagEffectLabel(p,PFLAG_SENT_CARD_COUNTER,ct,true)
		end
	end
end

--E1
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) or not re then return false end
	local rc=re:GetHandler()
	local ch=Duel.GetCurrentChain()
	if ch==0 or rc:IsRelateToChain(ch) then
		return rc:IsCode(CARD_MEMORIES_OF_THE_SANDSTAR)
	else
		local code1,code2=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		return code1==CARD_MEMORIES_OF_THE_SANDSTAR or code2==CARD_MEMORIES_OF_THE_SANDSTAR
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	c:Unaffected(UNAFFECTED_OPPO,nil,{RESET_PHASE|PHASE_END|RESET_OPPO_TURN,Duel.GetNextPhaseCount(nil,1-tp)},c,nil,nil,false)
	c:CannotBeDestroyedByBattle(1,nil,true,c,nil,nil,false)
end

--E2
function s.evfilter(c,_,tp)
	return c:IsControler(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.PlayerHasFlagEffect(1-tp,PFLAG_SENT_CARD_COUNTER) and Duel.GetFlagEffectLabel(1-tp,PFLAG_SENT_CARD_COUNTER)>=5 end
	local c=e:GetHandler()
	local g=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	Duel.SetTargetCard(g)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,0,#g*200)
	
	if e:IsActivated() then
		local ch=Duel.GetCurrentChain()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(id,2)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(function() return Duel.GetCurrentChain()>=ch end)
		e1:SetValue(function(_,re,rp) return re:GetHandler():IsControler(rp) and re:GetActivateLocation()==LOCATION_GRAVE end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards()
	local b1=g:IsExists(Card.IsAbleToHand,1,nil,tp)
	local b2=g:IsExists(Card.IsAbleToDeck,1,nil) and c:IsRelateToChain() and c:IsFaceup()
	if not b1 and not b2 then return end
	local opt=aux.Option(1-tp,id,3,b1,b2)
	if opt==0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif opt==1 then
		local ct=Duel.ShuffleIntoDeck(g)
		if ct>0 and c:IsRelateToChain() and c:IsFaceup() then
			c:UpdateATK(ct*200,true,c)
		end
	end
end