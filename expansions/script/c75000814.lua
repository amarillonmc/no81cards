--首位骑士 焰刃之艾利乌德
function c75000814.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000814,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75000814)
	--e1:SetCondition(c75000814.spcon)
	e1:SetCost(c75000814.spcost)
	e1:SetTarget(c75000814.sptg)
	e1:SetOperation(c75000814.spop)
	c:RegisterEffect(e1) 
 
end
function c75000814.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) 
end
function c75000814.costfilter(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c75000814.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75000814.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsLocation,LOCATION_HAND,LOCATION_DECK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsLocation,LOCATION_HAND,LOCATION_DECK)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c75000814.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000814.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75000814,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end
--