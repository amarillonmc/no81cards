--[[
剥落的记录
Faded Record
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Add, from your Deck to your hand, 1 card whose card type (Monster, Spell, Trap) matches the one of the bottom card of your GY. You must have 25 or more cards in your GY to activate and resolve this effect. 
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--If this is the only card in your hand, you can activate this card from your hand, and if you do, during your next Standby Phase, if this card is in your GY: You can add this card to your hand.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	e2:SetCost(s.handcost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e3:OPT()
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetGYCount(tp)>=25
end
function s.thfilter(c,type)
	return c:IsType(type) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=Duel.Group(Card.IsSequence,tp,LOCATION_GRAVE,0,nil,0):GetFirst()
		if not tc then return false end
		local type=tc:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP)
		return Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil,type)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not s.condition(e,tp,eg,ep,ev,re,r,rp) then return end
	local tc=Duel.Group(Card.IsSequence,tp,LOCATION_GRAVE,0,nil,0):GetFirst()
	if not tc then return false end
	local type=tc:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP)
	local sg=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,type)
	if #sg>0 then
		Duel.Search(sg,tp)
	end
end

--E2
function s.handcon(e)
	return Duel.GetHandCount(e:GetHandlerPlayer())==1
end
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_ACTIVATION|RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,0,Duel.GetNextPhaseCount(PHASE_STANDBY,tp))
end

--E3
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp and e:GetHandler():HasFlagEffect(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetCardOperationInfo(c,CATEGORY_TOHAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.Search(c,tp)
	end
end