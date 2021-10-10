--
function c188843.initial_effect(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188843,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,188843)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c188843.target)
	e1:SetOperation(c188843.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188843,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188843+100)
	e2:SetTarget(c188843.thtg)
	e2:SetOperation(c188843.thop)
	c:RegisterEffect(e2)
end
c188843.counter_add_list={0x10cb}
function c188843.counterfilter(c)
	return c:IsSetCard(0xcab) and ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)))
end
function c188843.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	local c=e:GetHandler()
	ct=Duel.GetMatchingGroupCount(c188840.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	if c:IsOnField() then ct=ct+1 end
	if chkc then return chkc:IsCanAddCounter(0x10cb,ct+1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x10cb,ct+1) and (not c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD))  end
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x10cb,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct+1,0,0)
end
function c188843.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	local ct=Duel.GetMatchingGroupCount(c188843.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
	if c:IsOnField() then ct=ct+1 end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x10cb,ct+1) then
		tc:AddCounter(0x10cb,ct+1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+54306223,e,0,0,0,0)
		if c:IsLocation(LOCATION_HAND) and not c:IsPublic() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c188843.thfilter(c,e,tp)
	if not (c:IsSetCard(0xcab) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c188843.filter(c,e,tp)
	local ct=c:GetCounter(0x10cb)
	local num=math.floor(ct/3)
	return ct>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(c188843.thfilter,tp,LOCATION_DECK,0,num,nil,e,tp)
end
function c188843.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:GetCounter(0x10cb)>0 and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c188843.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c188843.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	e:SetLabelObject(g:GetFirst())
end
function c188843.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=tc:GetCounter(0x10cb)
	if ct>0 then
		tc:RemoveCounter(tp,0x10cb,ct,REASON_EFFECT)
	else return false end
	local num=math.floor(ct/3)
	local g=Group.CreateGroup()
	if num>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		g=Duel.SelectMatchingCard(tp,c188843.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	end
	if num==0 or g:GetCount()==0 then return end
	Duel.BreakEffect()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local num=num-1
	while num>0 and Duel.IsExistingMatchingCard(c188843.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c188843.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		num=num-1
	end
end
