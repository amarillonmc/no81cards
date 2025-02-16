--浩瀚生态 聚引之双星
function c9911231.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9911231.discon)
	e2:SetOperation(c9911231.disop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911231)
	e3:SetCondition(c9911231.setcon)
	e3:SetTarget(c9911231.settg)
	e3:SetOperation(c9911231.setop)
	c:RegisterEffect(e3)
end
function c9911231.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and seq1==4-seq2
end
function c9911231.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and loc&LOCATION_SZONE==LOCATION_SZONE and seq<=4
		and Duel.IsExistingMatchingCard(c9911231.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c9911231.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911231)
	Duel.NegateEffect(ev)
end
function c9911231.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911231.setcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911231.filter,tp,LOCATION_MZONE,0,nil)
	return #g>0 and #g==g:FilterCount(Card.IsType,nil,TYPE_TUNER)
end
function c9911231.setfilter(c)
	local b1=c:IsLocation(LOCATION_HAND) and c:IsSSetable()
	local b2=c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true)
	local b3=c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x5958) and c:IsSSetable()
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and (b1 or b2 or b3)
end
function c9911231.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911233)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if fe then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c9911231.setfilter,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911231,0x5958,TYPES_NORMAL_TRAP_MONSTER,1250,500,2,RACE_PSYCHO,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911231.setop(e,tp,eg,ep,ev,re,r,rp)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911233)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if fe then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c9911231.setfilter,tp,loc,0,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if tc:IsLocation(LOCATION_DECK) then
			Duel.Hint(HINT_CARD,0,9911233)
			fe:UseCountLimit(tp)
		end
		if Duel.SSet(tp,tc)==0 then return end
	else
		tc:CancelToGrave()
		if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then return end
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local res=false
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9911231,0x5958,TYPES_NORMAL_TRAP_MONSTER,1250,500,2,RACE_PSYCHO,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		res=Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
	if res and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911231,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		Duel.SynchroSummon(tp,g:GetFirst(),nil)
	end
end
