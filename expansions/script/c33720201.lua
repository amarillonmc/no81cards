--[[
花花变身·动物朋友 狐獴
H-Anifriends Meerkat
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[This card's name becomes "Anifriends Meerkat" while on the field or in the GY.]]
	aux.EnableChangeCode(c,33701381,LOCATION_MZONE|LOCATION_GRAVE)
	--[[While this card is in your GY, and there are no cards with the same name in your GY: You can shuffle this card from your GY into the Deck, and if you do,
	return any number of cards from your hand to the bottom of the Deck, then excavate the same number of cards from the top of your Deck, and if you do,
	if all of them are cards with different names or with the same name, add them to your hand. Otherwise, return those cards to the top or bottom of your Deck, in any order.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TODECK|CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:HOPT()
	e1:SetFunctions(s.condition,nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetGY(tp)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() and Duel.IsExists(false,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanSendtoHand(tp)
	end
	Duel.SetCardOperationInfo(c,CATEGORY_TODECK)
	Duel.SetAdditionalOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.ShuffleIntoDeck(c)>0 then
		local hand=Duel.GetHand(tp):Filter(Card.IsAbleToDeck,nil)
		if #hand==0 then return end
		Duel.HintMessage(tp,HINTMSG_TODECK)
		local hg=hand:Select(tp,1,#hand,nil)
		if #hg>0 then
			local ct=aux.PlaceCardsOnDeckBottom(tp,hg,REASON_EFFECT)
			if ct==0 then return end
			Duel.ConfirmDecktop(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			if not g or #g<ct then return end
			local tg=g:Filter(Card.IsAbleToHand,nil)
			if #tg>0 then
				local dnct=g:GetClassCount(Card.GetCode)
				if dnct==1 or dnct==#g then
					Duel.DisableShuffleCheck()
					Duel.SendtoHand(tg,nil,REASON_EFFECT|REASON_REVEAL)
					Duel.ConfirmCards(1-tp,tg)
					Duel.ShuffleHand(tp)
					ct=ct-tg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_DECK)
				end
			end
			if ct>0 then
				local op=Duel.SelectOption(tp,STRING_DECKTOP,STRING_DECKBOTTOM)
				Duel.SortDecktop(tp,tp,ct)
				if op==0 then return end
				for i=1,ct do
					local tg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(tg:GetFirst(),SEQ_DECKBOTTOM)
				end
			end
		end
	end
end