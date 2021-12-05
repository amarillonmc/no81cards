--煌之集结
function c72412480.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72412480+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c72412480.target)
	e1:SetOperation(c72412480.activate)
	c:RegisterEffect(e1)
end
function c72412480.filter(c)
	return c:IsSetCard(0xe727) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72412480.cfilter(c)
	return c:IsSetCard(0x6727) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c72412480.filter2(c,e,tp)
	return c:IsSetCard(0xe727) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72412480.filter3(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412480.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412480.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72412480.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412480.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local n=Duel.GetMatchingGroupCount(c72412480.cfilter,tp,LOCATION_MZONE,0,nil)
			if n>=2  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c72412480.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,c72412480.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
				end
			end
			Duel.BreakEffect()
			if n>=4 then
					local g3=Duel.GetMatchingGroup(c72412480.filter3,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
					if g3:GetCount()~=0 then
					Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
					end
			end
		end
	end
end
