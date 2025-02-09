--Restless Sepialife
--Scripted by:XGlitchy30

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[At the start of your Main Phase 1: Add 2 "Sepialife" monsters with different names from your hand to your opponent's hand, and they will remain revealed, then it becomes the End Phase of this
	turn. If your opponent has more cards in their hand than you do when this effect resolves, you can add to your opponent's hand, 2 "Sepialife" monsters with different names from your Deck instead.]]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(ARCHE_SEPIALIFE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local fixct=(c:IsLocation(LOCATION_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE)) and 1 or 0
		local handcon=Duel.GetHandCount(tp)-fixct<Duel.GetHandCount(1-tp)
		local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
		local g2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
		return g1:GetClassCount(Card.GetCode)>=2 or (handcon and g2:GetClassCount(Card.GetCode)>=2)
	end
end
function s.gcheck(g,e,tp,mg,c)
    local valid = g:GetClassCount(Card.GetCode)==#g and g:GetClassCount(Card.GetLocation)==1
    local razor = {s.razorfilter,c:GetLocation(),c:GetCode()}
    return valid,false,razor
end
function s.razorfilter(c,loc,...)
	return c:IsLocation(loc) and not c:IsCode(...)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local locs=LOCATION_HAND
	if Duel.GetHandCount(tp)<Duel.GetHandCount(1-tp) then
		locs=locs|LOCATION_DECK
	end
	local g=Duel.GetMatchingGroup(s.filter,tp,locs,0,nil)
	local tg1=xgl.SelectUnselectGroup(g,e,tp,2,2,s.gcheck,1,tp,HINTMSG_ATOHAND)
	if Duel.SendtoHand(tg1,1-tp,REASON_EFFECT)>0 then
		local sg=tg1:Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,1-tp)
		if #sg>0 then
			local c=e:GetHandler()
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		end
	end	
end