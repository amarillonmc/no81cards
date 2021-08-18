--铁战灵兽 急速折返
function c33200065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,33200065+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(c33200065.tg)  
	e1:SetOperation(c33200065.op)
	c:RegisterEffect(e1)
end

--e1
function c33200065.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x322) and c:IsAbleToHand() and c:IsLevelAbove(5)
end
function c33200065.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x322) and not c:IsLevel(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200065.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33200065.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200065.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c33200065.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33200065.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c33200065.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
			if g:GetCount()~=0 then
				local tc1=g:GetFirst()  
				Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)  
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(1)
				tc1:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
