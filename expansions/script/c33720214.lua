--[[
晦空士 ～负罪的绿欲～
Sepialife - Guilt On Green
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[During the End Phase, if this card is Special Summoned: Look at your opponent's hand, and place a number of cards from their hand on the bottom of their Deck in any order, 
	up to the number of other "Sepialife" monsters you control, and if you do, they draw the same number of cards +1 and reveal them.
	If a "Sepialife" card(s) is returned to their Deck and/or is added to their hand by this effect, you draw the same number of cards, then send the same number of cards from your hand to the GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DRAW|CATEGORY_TODECK|CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.EndPhaseCond(),nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function s.tdfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToDeck()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local hand=Duel.GetHand(1-tp)
	if #hand>0 then
		Duel.ConfirmCards(tp,hand)
		local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,ARCHE_SEPIALIFE),tp,LOCATION_MZONE,0,aux.ExceptThis(e))
		if ct>0 then
			Duel.HintMessage(tp,HINTMSG_TODECK)
			local tg=hand:FilterSelect(tp,Card.IsAbleToDeck,1,ct,nil)
			if #tg>0 then
				local SepiaShuffledGroup=tg:Filter(Card.IsSetCard,nil,ARCHE_SEPIALIFE)
				if Duel.SendtoDeck(tg,1-tp,SEQ_DECKTOP,REASON_EFFECT)>0 then
					local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,1-tp,LOCATION_DECK)
					local ct=#og
					if ct>0 then
						local SepiaCount=SepiaShuffledGroup:FilterCount(Card.IsContained,nil,og)
						Duel.SortDecktop(tp,1-tp,ct)
						for i=1,ct do
							local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
							Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
						end
						if Duel.Draw(1-tp,ct+1,REASON_EFFECT)>0 then
							local drawog=Duel.GetGroupOperatedByThisEffect(e)
							if #drawog>0 then
								Duel.ConfirmCards(tp,drawog)
								SepiaCount=SepiaCount+drawog:FilterCount(Card.IsSetCard,nil,ARCHE_SEPIALIFE)
							end
						end
						if SepiaCount>0 and Duel.Draw(tp,SepiaCount,REASON_EFFECT)>0 then
							Duel.ShuffleHand(tp)
							local hand2=Duel.GetHand(tp)
							Duel.HintMessage(tp,HINTMSG_TOGRAVE)
							local tg2=hand2:FilterSelect(tp,Card.IsAbleToGrave,SepiaCount,SepiaCount,nil)
							if #tg2>0 then
								Duel.BreakEffect()
								Duel.SendtoGrave(tg2,REASON_EFFECT)
							end
						end	
					end
				end
			end
		end
	end
end