--我反对！
function c33200520.initial_effect(c)
	aux.AddCodeList(c,33200500)
	aux.AddCodeList(c,33200501)
	aux.AddCodeList(c,33200511)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33200520.condition)
	e1:SetCost(c33200520.negcost)
	e1:SetTarget(c33200520.negtg)
	e1:SetOperation(c33200520.negop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,33200520)
	e2:SetTarget(c33200520.sptg)
	e2:SetOperation(c33200520.spop)
	c:RegisterEffect(e2) 
end


--e1
function c33200520.coffilter(c)
   return c:GetFlagEffect(33200507)>0 and not c:IsDisabled()
end
function c33200520.offilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,33200500) and c:IsType(TYPE_MONSTER)
end
function c33200520.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33200520.offilter,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c33200520.shfilter(c,rtype)
	return c:IsType(rtype) and not c:IsPublic()
end
function c33200520.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200520.shfilter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.Hint(24,0,aux.Stringid(33200520,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33200520.shfilter,tp,LOCATION_HAND,0,1,1,nil,rtype)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
end
function c33200520.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200520.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
		local dtm=Duel.GetFlagEffect(tp,33200506)
		local co=Duel.GetMatchingGroup(c33200520.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
		local cof=co:GetCount()
		if dtm>cof then dtm=cof end
		if Duel.Damage(1-tp,800,REASON_EFFECT) and dtm>=1 then
			Duel.Hint(HINT_CARD,tp,33200506)
			Duel.Draw(tp,dtm,REASON_EFFECT)
			for drc in aux.Next(co) do
				drc:RegisterFlagEffect(33200508,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end

--e2
function c33200520.spfilter(c,e,tp)
	return (c:IsCode(33200501) or c:IsCode(33200511) or aux.IsCodeListed(c,33200501) or aux.IsCodeListed(c,33200511)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200520.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33200520.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33200520.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
