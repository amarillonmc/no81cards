--沧海姬的呼吸
function c9911013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911013.target)
	e1:SetOperation(c9911013.activate)
	c:RegisterEffect(e1)
end
function c9911013.filter1(c,tp)
	local check=c:IsSetCard(0x6954)
	return c:IsFaceup() and c:IsAbleToHand()
		and Duel.IsExistingTarget(c9911013.filter2,tp,LOCATION_GRAVE,0,1,nil,check)
end
function c9911013.filter2(c,check)
	return c:IsReason(REASON_RELEASE) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToDeck() or (check and c:IsAbleToHand()))
end
function c9911013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911013.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911013,0))
	local g1=Duel.SelectTarget(tp,c9911013.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local mc=g1:GetFirst()
	e:SetLabelObject(mc)
	local check=mc:IsSetCard(0x6954)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911013,1))
	local g2=Duel.SelectTarget(tp,c9911013.filter2,tp,LOCATION_GRAVE,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function c9911013.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local gc=g:GetFirst()
	if gc==mc then gc=g:GetNext() end
	if not gc or not gc:IsRelateToEffect(e) or not gc:IsLocation(LOCATION_GRAVE) then return end
	local b1=mc and mc:IsRelateToEffect(e) and mc:IsLocation(LOCATION_MZONE)
	local b2=gc:IsSetCard(0x6954)
	if b1 and mc:IsSetCard(0x6954) and gc:IsAbleToHand()
		and (not gc:IsAbleToDeck() or Duel.SelectOption(tp,1190,aux.Stringid(9911013,2))==0) then
		if Duel.SendtoHand(gc,nil,REASON_EFFECT)==0 or not gc:IsLocation(LOCATION_HAND) then return end
	else
		if Duel.SendtoDeck(gc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0
			or not gc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
	end
	if b1 and Duel.SendtoHand(mc,nil,REASON_EFFECT)~=0 and mc:IsLocation(LOCATION_HAND) and b2
		and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(9911013,3)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
