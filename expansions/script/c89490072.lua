--天竺的托宣
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOKEN+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return aux.IsCodeListed(c,id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local g1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if tc:IsAttribute(ATTRIBUTE_EARTH) and #g1>0 and Duel.GetMZoneCount(1-tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc1=g1:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(sc1,0,tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc1:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,89490073,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEASTWARRIOR,ATTRIBUTE_WATER) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,89490073)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
		local g3=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK,0,nil)
		if tc:IsAttribute(ATTRIBUTE_WIND) and #g3>0 and Duel.GetMZoneCount(1-tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg3=g3:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.Remove(sg3,POS_FACEUP,REASON_EFFECT)
		end
	end
end
