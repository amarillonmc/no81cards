--[[
花花变身·动物朋友 豺狗
H-Anifriends Dhole
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[This card's name becomes "Anifriends Dhole" while on the field or in the GY.]]
	aux.EnableChangeCode(c,33701380,LOCATION_MZONE|LOCATION_GRAVE)
	--[[While this card is in your GY, and there are no cards with the same name in your GY: You can shuffle this card from your GY into the Deck, and if you do,
	excavate the top 3 cards of your Deck, and if all of them are cards with different names, add 1 of them to your hand. Otherwise, if all of them are cards with the same name,
	add all of them to your hand. Also, return the rest to the top or bottom of the Deck in any order.]]
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
		return c:IsAbleToDeck() and Duel.IsPlayerCanExcavateAndSearch(tp,3)
	end
	Duel.SetCardOperationInfo(c,CATEGORY_TODECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.ShuffleIntoDeck(c)>0 then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if not g or #g<3 then return end
		local tg=g:Filter(Card.IsAbleToHand,nil)
		local ct=3
		if #tg>0 then
			local dnct=g:GetClassCount(Card.GetCode)
			if dnct==#g then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=tg:Select(tp,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(sg,nil,REASON_EFFECT|REASON_REVEAL)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				if not sg:GetFirst():IsLocation(LOCATION_DECK) then
					ct=ct-1
				end
			elseif dnct==1 then
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