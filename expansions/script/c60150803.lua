--爱莎-星界游行
function c60150803.initial_effect(c)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60150803)
	e2:SetCost(c60150803.cost)
	e2:SetTarget(c60150803.sstg)
	e2:SetOperation(c60150803.ssop)
	c:RegisterEffect(e2)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,6010803)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c60150803.spcost)
	e1:SetTarget(c60150803.sptg)
	e1:SetOperation(c60150803.spop)
	c:RegisterEffect(e1)
end
function c60150803.costfilter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c60150803.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150803.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c60150803.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c60150803.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetMatchingGroup(c60150803.filter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
	local g2=Duel.GetMatchingGroup(c60150803.filter2,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,g2,1,0,0)
end
function c60150803.filter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c60150803.filter2(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function c60150803.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c60150803.filter,tp,LOCATION_DECK,0,nil)
			local g2=Duel.GetMatchingGroup(c60150803.filter2,tp,LOCATION_HAND,0,nil)
			if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150803,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150803,0))
				local sg=g2:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
					if Duel.SelectYesNo(tp,aux.Stringid(60150803,2)) then
						Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
					else
						Duel.SendtoGrave(tc,REASON_EFFECT)
					end
				elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g3=Duel.SelectMatchingCard(tp,c60150803.filter,tp,LOCATION_DECK,0,1,1,nil)
				if g3:GetCount()>0 then
					Duel.SendtoHand(g3,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g3)
				end
			end
		end
	end
end
function c60150803.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60150803.filter23(c,e,tp)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c60150803.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c60150803.filter23(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150803.filter23,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150803.filter23,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150803.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end