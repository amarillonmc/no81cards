--闪耀的一等星 樱木真乃
function c28315548.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--illumination spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315548,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315548)
	e1:SetTarget(c28315548.sptg)
	e1:SetCost(c28315548.cost)
	e1:SetOperation(c28315548.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315548,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,28315548+1)
	e2:SetTarget(c28315548.thtg)
	e2:SetOperation(c28315548.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c28315548.tdfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c28315548.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c28315548.tdfilter(chkc) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c28315548.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	local ct=0
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if Duel.GetOperatedGroup():IsExists(Card.IsCode,1,nil,28335405) then ct=ct+1 end
	end
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and ct>0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e0:SetValue(ct)
		c:RegisterEffect(e0)
	end
end
function c28315548.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28315548.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315548.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local ct=e:GetHandler():IsSummonLocation(LOCATION_HAND) and 1 or 0
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28315548.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c28315548.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28315548.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if e:GetLabel()==0 or not Duel.IsExistingMatchingCard(c28315548.tgfilter,tp,LOCATION_DECK,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(28315548,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28315548.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.BreakEffect()
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c28315548.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28315548) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28315548,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28315548,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28318749,e,0,0,0,0)
end
