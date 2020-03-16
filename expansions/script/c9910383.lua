--雪之光的祝福
function c9910383.initial_effect(c)
	aux.AddCodeList(c,9910376)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,9910383+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910383.target)
	e1:SetOperation(c9910383.activate)
	c:RegisterEffect(e1)
end
function c9910383.filter(c,e,tp)
	return aux.IsCodeListed(c,9910376) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910383.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910383.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910383.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910383.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9910383.thfilter(c)
	return aux.IsCodeListed(c,9910376) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910383.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e3)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910383.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
		if Duel.GetFlagEffect(tp,9910383)==0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,9910376)
			and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910383,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.RegisterFlagEffect(tp,9910383,0,0,1)
		end
	end
end
