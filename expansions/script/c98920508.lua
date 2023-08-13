--天位贤者
function c98920508.initial_effect(c)
	--to hand&ssp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920508,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920508)
	e1:SetCondition(c98920508.thcon)
	e1:SetCost(c98920508.thcost)
	e1:SetTarget(c98920508.thtg)
	e1:SetOperation(c98920508.thop)
	c:RegisterEffect(e1)
end
function c98920508.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c98920508.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920508.filter1(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920508.filter2(c)
	return c:IsType(TYPE_NORMAL)
end
function c98920508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920508.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:GetCount()>2 and g:IsExists(c98920508.filter2,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98920508.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920508.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if g:IsExists(c98920508.filter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local cg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tg=cg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			   local e1=Effect.CreateEffect(e:GetHandler())
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetCode(EFFECT_DISABLE)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			   local e2=Effect.CreateEffect(e:GetHandler())
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_DISABLE_EFFECT)
			   e2:SetValue(RESET_TURN_SET)
			   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e2)
			 end
			Duel.SpecialSummonComplete()
			cg:RemoveCard(tc)
		end
		if cg:IsExists(c98920508.filter2,1,nil) then
		   Duel.SendtoHand(cg:Filter(c98920508.filter2,nil),tp,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end