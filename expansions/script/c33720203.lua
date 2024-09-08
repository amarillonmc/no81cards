--[[
花花变身·动物朋友 真海豚
H-Anifriends C. Dolphin
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[This card's name becomes "Anifriends "Malka"" while on the field or in the GY.]]
	aux.EnableChangeCode(c,33700741,LOCATION_MZONE|LOCATION_GRAVE)
	--[[While this card is in your GY, and there are no cards with the same name in your GY: You can shuffle this card from your GY into the Deck, and if you do,
	excavate a number of cards from the top of your Deck, equal to the number of monsters your opponent controls, and if all excavated cards have different names,
	you can Special Summon 1 monster from among them. Otherwise, if all of them are monsters with the same name, you can Special Summon all of them.
	Also, return the rest to the top or bottom of your Deck, in any order.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_DECKDES|CATEGORY_SPECIAL_SUMMON)
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
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		return c:IsAbleToDeck() and ct>0 and Duel.GetDeckCount(tp)>=ct
	end
	Duel.SetCardOperationInfo(c,CATEGORY_TODECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.ShuffleIntoDeck(c)>0 then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		if ct==0 then return end
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if not g or #g<ct then return end
		local tg=g:Filter(s.spfilter,nil,e,tp)
		if #tg>0 then
			local ft=Duel.GetMZoneCount(tp)
			local dnct=g:GetClassCount(Card.GetCode)
			if dnct==#g and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.HintMessage(tp,HINTMSG_SPSUMMON)
				local sg=tg:Select(tp,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				if not sg:GetFirst():IsLocation(LOCATION_DECK) then
					ct=ct-1
				end
			
			elseif dnct==1 and #g==#tg and ft>=#g and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.DisableShuffleCheck()
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
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