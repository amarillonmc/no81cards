--[[
黑夜泛舟
Sail Across the Unknown
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[After you activate this card, you cannot add cards from your Deck to your hand (expect by this card's effects), or shuffle cards into your Deck for the rest of this turn. Shuffle your Deck,
	and if you do, your opponent can choose to look at the top 3 or 6 cards of your Deck, and if they do, they can place those cards on the top of your Deck in any order, and if they do that, you can
	add 1 card from the bottom of your Deck for each 3 cards they looked at.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT(true)
	e1:SetFunctions(nil,s.cost,s.target,s.activate)
	c:RegisterEffect(e1)
end
--E1
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetLabel(0)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.limtg)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterHint(tp,id,PHASE_END,1,id,1)
end
function s.limtg(e,c,tp,re)
	return c:IsLocation(LOCATION_DECK) and (not re or re:GetFieldID()~=e:GetLabel())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDeckCount(tp)>=3 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:SetLabel(e:GetFieldID()) end
	Duel.ShuffleDeck(tp)
	local ct=Duel.GetDeckCount(tp)
	if ct<3 then return end
	local nums={3}
	if ct>=6 then
		table.insert(nums,6)
	end
	local n=Duel.AnnounceNumber(1-tp,table.unpack(nums))
	local tg=Duel.GetDecktopGroup(tp,n)
	Duel.DisableShuffleCheck()
	Duel.ConfirmCards(1-tp,tg)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.SortDecktop(1-tp,tp,n)
	end
	local g=Duel.GetDeck(tp):Filter(Card.IsSequenceBelow,nil,math.floor(n/3)-1):Filter(Card.IsAbleToHand,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end