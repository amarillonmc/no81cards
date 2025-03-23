--冤魂束缚的恋慕屋敷
function c9911067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911067.target)
	e1:SetOperation(c9911067.activate)
	e1:SetValue(c9911067.zones)
	c:RegisterEffect(e1)
end
function c9911067.filter(c,b)
	return c:IsSetCard(0x9954) and c:IsType(TYPE_PENDULUM) and ((b and not c:IsForbidden()) or c:IsAbleToHand())
end
function c9911067.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c9911067.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local sp=Duel.IsExistingMatchingCard(c9911067.filter,tp,LOCATION_DECK,0,1,nil,false)
		or Duel.IsExistingMatchingCard(c9911067.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
	if p0==p1 or sp then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c9911067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g1=Duel.GetMatchingGroup(c9911067.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c9911067.filter,tp,LOCATION_DECK,0,nil,b)
	if chk==0 then return #g1+#g2>0 end
	local s=0
	if #g1>0 and #g2==0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911067,0))
	end
	if #g1==0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911067,1))+1
	end
	if #g1>0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911067,0),aux.Stringid(9911067,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c9911067.tgfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsControler(tp) and c:IsAbleToGrave()
end
function c9911067.activate(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911067.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c9911067.filter,tp,LOCATION_DECK,0,nil,b)
	if e:GetLabel()==0 and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if not tc or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local g=tc:GetColumnGroup():Filter(c9911067.tgfilter,nil,1-tp)
		if #g>0 and Duel.IsCanRemoveCounter(tp,1,1,0x1954,3,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(9911067,2)) then
			Duel.BreakEffect()
			if not Duel.RemoveCounter(tp,1,1,0x1954,3,REASON_EFFECT) then return end
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	if e:GetLabel()==1 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		local b1=tc:IsAbleToHand()
		local b2=b and not tc:IsForbidden()
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1160)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
