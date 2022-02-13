--辉熠的诺格卓尔
function c9910901.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910901)
	e1:SetCondition(c9910901.spcon)
	e1:SetTarget(c9910901.sptg)
	e1:SetOperation(c9910901.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910902)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910901.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910901.distg)
	e2:SetOperation(c9910901.disop)
	c:RegisterEffect(e2)
end
function c9910901.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910901.drfilter(c)
	return aux.IsCodeListed(c,9910871) and not c:IsPublic()
end
function c9910901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c9910901.drfilter,tp,LOCATION_HAND,0,nil)
	if Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,SUMMON_TYPE_ADVANCE)
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910901,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9910901.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c9910901.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910901.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910901.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9910901.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
