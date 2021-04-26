--温暖的韶光 妃玲奈
function c9910460.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
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
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910460.negcon)
	e2:SetOperation(c9910460.negop)
	c:RegisterEffect(e2)
end
function c9910460.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1950,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1950,2,REASON_COST)
end
function c9910460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910460.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9950)
end
function c9910460.ctfilter(c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return c:IsCanAddCounter(0x1950,1) and g:IsExists(c9910460.cfilter,1,nil)
end
function c9910460.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c9910460.ctfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910460,0)) then
			local tc=g:GetFirst()
			while tc do
				tc:AddCounter(0x1950,1)
				tc=g:GetNext()
			end
		end
	end
end
function c9910460.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc and rc:IsControler(1-tp)
		and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(9910460)<=0
end
function c9910460.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc:IsCanRemoveCounter(tp,0x1950,1,REASON_EFFECT) then return end
	Duel.HintSelection(Group.FromCards(c))
	if Duel.SelectYesNo(tp,aux.Stringid(9910460,1)) then
		Duel.Hint(HINT_CARD,0,9910460)
		rc:RemoveCounter(tp,0x1950,1,REASON_EFFECT)
		if Duel.NegateEffect(ev) and c:IsCanAddCounter(0x1950,1)
			and Duel.SelectYesNo(tp,aux.Stringid(9910460,0)) then
			Duel.BreakEffect()
			c:AddCounter(0x1950,1)
		end
		c:RegisterFlagEffect(9910460,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
