--匪魔追缉者 克险尖兵
function c9910937.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910937,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910937)
	e1:SetCondition(c9910937.spcon)
	e1:SetTarget(c9910937.sptg)
	e1:SetOperation(c9910937.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910937,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910938)
	e2:SetCondition(c9910937.thcon)
	e2:SetTarget(c9910937.thtg)
	e2:SetOperation(c9910937.thop)
	c:RegisterEffect(e2)
	--leave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9910937.flagcon)
	e3:SetOperation(c9910937.flagop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910937,ACTIVITY_CHAIN,c9910937.chainfilter)
end
function c9910937.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c9910937.spcon(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()
	return chain>1 or (Duel.GetFlagEffect(tp,9920937)~=0 and chain>0)
end
function c9910937.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910937.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c9910937.negcon)
	e1:SetOperation(c9910937.negop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c9910937.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE and Duel.GetFlagEffect(tp,9910937)==0
end
function c9910937.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910937)
	Duel.RegisterFlagEffect(tp,9910937,RESET_CHAIN,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
	e:Reset()
end
function c9910937.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c9910937.cfilter(c,code)
	return c:IsFaceupEx() and c:IsCode(code)
end
function c9910937.thfilter(c,tp)
	return c:IsSetCard(0x3954) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9910937.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c9910937.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910937.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910937.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910937.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and (Duel.GetCustomActivityCount(9910937,tp,ACTIVITY_CHAIN)~=0
			or Duel.GetCustomActivityCount(9910937,1-tp,ACTIVITY_CHAIN)~=0)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910937,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c9910937.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c9910937.flagop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910937,3))
end
