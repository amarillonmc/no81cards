--[[
砂之星之奇遇
Encounter of the Sandstar
Incontro della Sabbiastella
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Reveal any number of "Anifriends" cards in your hand; excavate an equal number of cards from the top of your Deck, and if you do,
	if all of them are "Anifriends" monsters with different names from each other, you can add 1 of them to your hand, and if you do that,
	apply the following effects in sequence, based on the number of "Anifriends" monsters excavated this way.
	●3+: Special Summon 1 of those monsters.
	●5+: Add the rest of the excavated cards to your hand.
	Also, place the rest of the excavated cards on the top or the bottom of your Deck, in any order.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END|TIMING_END_PHASE)
	e1:SetCost(aux.DummyCost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.rvfilter(c)
	return c:IsSetCard(0x442) and not c:IsPublic()
end
function s.excfilter(c)
	return not c:IsSetCard(0x442) or not c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then
		local c=e:GetHandler()
		local exc
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_HAND) then
			exc=c
		end
		return e:IsCostChecked() and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,exc) and ct>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,ct,nil)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SetTargetParam(#rg)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if not ct or ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if aux.dncheck(g) and not g:IsExists(s.excfilter,1,nil) then
		Duel.DisableShuffleCheck(true)
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT|REASON_REVEAL)>0 and tc:IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,tc)
				Duel.ShuffleHand(tp)
				g:RemoveCard(tc)
				local breakeff=false
				if ct>=3 and Duel.GetMZoneCount(tp)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
					if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
						breakeff=true
						g:RemoveCard(sc)
					end
				end
				if ct>=5 and #g>0 and not g:IsExists(aux.NOT(Card.IsAbleToHand),1,nil) then
					if breakeff then
						Duel.BreakEffect()
					end
					if Duel.SendtoHand(g,nil,REASON_EFFECT|REASON_REVEAL)>0 then
						local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
						Duel.ConfirmCards(1-tp,hg)
						Duel.ShuffleHand(tp)
						g:Sub(hg)
					end
				end
			end
		end
	end
	if #g>0 then
		local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		Duel.SortDecktop(tp,tp,#g)
		if opt==1 then
			for i=1,#g do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	end
end