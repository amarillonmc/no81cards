--
function c188840.initial_effect(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188840,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,188840)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c188840.target)
	e1:SetOperation(c188840.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	--To grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188840,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188840+100)
	e2:SetTarget(c188840.gvtg)
	e2:SetOperation(c188840.gvop)
	c:RegisterEffect(e2)
end
c188840.counter_add_list={0x10cb}
function c188840.counterfilter(c)
	return c:IsSetCard(0xcab) and ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)))
end
function c188840.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	local c=e:GetHandler()
	ct=Duel.GetMatchingGroupCount(c188840.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	if c:IsOnField() then ct=ct+1 end
	if chkc then return chkc:IsCanAddCounter(0x10cb,ct+1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x10cb,ct+1) and (not c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD))  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x10cb,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct+1,0,0)
end
function c188840.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	local ct=Duel.GetMatchingGroupCount(c188840.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
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
function c188840.filter(c,e,tp)
	local lv=c:GetCounter(0x10cb)
	return lv>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c188840.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,lv,c)
end
function c188840.spfilter(c,e,tp,lv,mc)
	return c:IsSetCard(0xcab) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c188840.chkfilter(c,tc)
	local lv=c:GetCounter(0x10cb)
	return c:IsFaceup() and tc:IsLevelBelow(lv)
end
function c188840.gvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c188840.chkfilter(chkc,e:GetLabelObject()) end
	if chk==0 then return Duel.IsExistingTarget(c188840.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c188840.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
	e:SetLabelObject(g:GetFirst())
end
function c188840.gvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetCounter(0x10cb)
	if lv>0 then
		tc:RemoveCounter(tp,0x10cb,ct,REASON_EFFECT)
	else return false end
	Duel.BreakEffect()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c188840.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,lv,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
