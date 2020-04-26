--温暖的韶光 妃玲奈
function c9910460.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910460)
	e1:SetCondition(c9910460.spcon)
	e1:SetCost(c9910460.spcost)
	e1:SetTarget(c9910460.sptg)
	e1:SetOperation(c9910460.spop)
	c:RegisterEffect(e1)
end
function c9910460.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910460.cfilter(c)
	return not c:IsPublic()
end
function c9910460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910460.cfilter,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=g:SelectSubGroup(tp,aux.dncheck,false,2,g:GetCount())
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
	e:SetLabel(rg:GetCount())
end
function c9910460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local ct=e:GetLabel()
	local cat=CATEGORY_SPECIAL_SUMMON
	if ct>2 then cat=cat+CATEGORY_DRAW end
	if ct>3 then cat=cat+CATEGORY_DISABLE end
	e:SetCategory(cat)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910460.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=e:GetLabel()
		if ct>2 and Duel.IsPlayerCanDraw(tp)
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910460,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,2,nil)
			if dg:GetCount()==0 or Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)==0 then return end
			local og=dg:Filter(Card.IsLocation,nil,LOCATION_DECK)
			if og:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
			if og:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
			Duel.BreakEffect()
			Duel.Draw(tp,dg:GetCount(),REASON_EFFECT)
		end
		if ct>3 and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910460,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,2,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			while tc do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				tc=sg:GetNext()
			end
		end
	end
end
