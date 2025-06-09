--狰咤意气之剑域
function c9911716.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911716.target)
	e1:SetOperation(c9911716.activate)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c9911716.negcon)
	e3:SetOperation(c9911716.negop)
	c:RegisterEffect(e3)
end
function c9911716.spfilter(c,e,tp)
	return c:IsSetCard(0x9957) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911716.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) and c~=chkc end
	if chk==0 then return Duel.GetFlagEffect(tp,9911716)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911716.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.RegisterFlagEffect(tp,9911716,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9911716.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9911716.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
				local c=e:GetHandler()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end
function c9911716.cfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x9957) and c:IsReleasableByEffect() and not c:IsImmuneToEffect(e)
end
function c9911716.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckReleaseGroupEx(tp,c9911716.cfilter,1,REASON_EFFECT,false,nil,e) and e:GetHandler():IsAbleToDeck()
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9911716)<1
end
function c9911716.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9911716)<1 and not Duel.IsChainDisabled(ev)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(9911716,0)) then
		local g=Duel.SelectReleaseGroupEx(tp,c9911716.cfilter,1,1,REASON_EFFECT,false,nil,e)
		if #g>0 and Duel.Release(g,REASON_EFFECT)>0 then
			Duel.Hint(HINT_CARD,0,9911716)
			if Duel.NegateEffect(ev) then
				Duel.BreakEffect()
				Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
		Duel.RegisterFlagEffect(tp,9911716,RESET_PHASE+PHASE_END,0,1)
	end
end
