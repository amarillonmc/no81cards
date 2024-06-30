--[[
晦空士明暗雷
Sepialife Overspark
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[During the End Phase: Both players reveal their hands, also inflict damage to each player equal to the number of "Sepialife" cards in their opponent's hand x 400.
	Each player can look at their opponent's Deck and send any number of "Sepialife" cards from that Deck to the GY, and for each card sent to the GY this way,
	the damage that player would take is reduced by 400 (they cannot send any more cards to the GY after the damage is reduced to 0).]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetFunctions(aux.EndPhaseCond(),nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ft=(c:IsLocation(LOCATION_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE)) and 1 or 0
		return Duel.GetHandCount(tp)>ft and Duel.GetHandCount(1-tp)>0
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.tgfilter(c,p)
	return c:IsSetCard(ARCHE_SEPIALIFE) and not c:IsHasEffect(EFFECT_CANNOT_TO_GRAVE) and Duel.IsPlayerCanSendtoGrave(p,c)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	for p in aux.TurnPlayers() do
		local hand=Duel.GetHand(1-p)
		if #hand>0 then
			Duel.ConfirmCards(p,hand)
			local ct=hand:FilterCount(Card.IsSetCard,nil,ARCHE_SEPIALIFE)
			if ct>0 then
				local deck=Duel.GetDeck(1-p)
				if #deck>0 and Duel.SelectYesNo(p,aux.Stringid(id,1)) then
					Duel.ConfirmCards(p,deck)
					Duel.HintMessage(p,HINTMSG_TOGRAVE)
					local tg=deck:FilterSelect(p,s.tgfilter,1,ct,nil,p)
					if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT,p)>0 then
						local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
						ct=ct-#og
					end
				end
				if ct>0 then
					Duel.Damage(p,ct*400,REASON_EFFECT,true)
				end
			end
			Duel.ShuffleHand(1-p)
		end
	end
	Duel.RDComplete()
end