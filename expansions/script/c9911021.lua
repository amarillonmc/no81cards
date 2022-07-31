--沧海姬的流逝
function c9911021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911021.target)
	e1:SetOperation(c9911021.activate)
	c:RegisterEffect(e1)
end
function c9911021.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>1 and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c9911021.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c9911021.filter2(c,e,tp,tc)
	local res=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return c:IsSetCard(0x6954) and c:IsLevelBelow(tc:GetLevel()-1) and (c:IsAbleToHand() or res)
end
function c9911021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911021.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911021.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c9911021.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9911021.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sc=g:GetFirst()
	local res=false
	if sc then
		if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			res=Duel.SendtoHand(sc,nil,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_HAND)
			Duel.ConfirmCards(1-tp,sc)
		else
			res=Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0
		end
	end
	if res and Duel.Release(tc,REASON_EFFECT)>0 then res=true end
	if res and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
		and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(9911021,0)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
