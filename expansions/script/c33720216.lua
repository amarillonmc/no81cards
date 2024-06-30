--[[
晦空士 ～高啸的靛痛～
Sepialife - Cries On Cyan
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[(Quick Effect): You can Tribute this card; look at your opponent's Deck, also apply 1 of these effects.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_TODECK|CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,aux.TributeSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
	--[[During the End Phase, if you did not activate a non-"Sepialife" card effect this turn, and this card is in your GY:
	You can shuffle this card into your opponent's Deck; shuffle up to 2 "Sepialife" monsters from your GY into your opponent's Deck.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SHOPT()
	e2:SetFunctions(s.tdcon,s.tdcost,s.tdtg,s.tdop)
	c:RegisterEffect(e2)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_SEPIALIFE)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.CheckArchetypeReasonEffect(s,re,ARCHE_SEPIALIFE) then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE|PHASE_END,0,1)
	end
end

--E1
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToHand()
end
function s.tdfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDeck(1-tp)
		return g:IsExists(aux.excthfilter,1,nil,tp) or Duel.IsExists(false,s.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDeck(1-tp)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
	end
	local b1=g:IsExists(s.thfilter,1,nil)
	local b2=Duel.IsExists(false,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,nil)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,nil,nil,{b1,STRING_ADD_TO_HAND},{b2,STRING_SEND_TO_DECK})
	----Add 1 "Sepialife" monster from their Deck to their hand, and if you do, they keep it revealed.
	if opt==0 then
		Duel.HintMessage(tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,s.thfilter,1,1,nil)
		if #tg>0 and Duel.SearchAndCheck(tg,nil,1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(66)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tg:GetFirst():RegisterEffect(e1)
		end
		
	----Shuffle 1 "Sepialife" monster from your GY into their Deck.
	elseif opt==1 then
		local tg=Duel.Select(HINTMSG_TODECK,false,tp,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #tg>0 then
			Duel.HintSelection(tg)
			Duel.ShuffleIntoDeck(tg,1-tp)
		end
	end
end

--E2
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.PlayerHasFlagEffect(tp,id)
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,1-tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExists(false,s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end