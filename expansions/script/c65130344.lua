--暗黑伊吕波
function c65130344.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	c:RegisterEffect(e1)
	--to Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130344,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65130344)
	e2:SetTarget(c65130344.tgtg)
	e2:SetOperation(c65130344.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c65130344.cfilter(c) 
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsLocation(LOCATION_GRAVE)
end
function c65130344.filter2(c) 
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65130344.filter(c) 
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsAbleToGrave()
end
function c65130344.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65130344.filter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c65130344.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65130344.cfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65130344.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local g1=Duel.GetMatchingGroup(c65130344.filter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c65130344.filter,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c65130344.cfilter,tp,LOCATION_GRAVE,0,3,nil) and g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65130344,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc =g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else 
		if g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc =g1:Select(tp,1,1,nil)
			Duel.SendtoGrave(tc,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end