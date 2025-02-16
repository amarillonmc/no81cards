--浩瀚生态 无垠之深海
function c9911218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9911218.accon)
	e2:SetValue(c9911218.aclimit)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911218)
	e3:SetCondition(c9911218.setcon)
	e3:SetTarget(c9911218.settg)
	e3:SetOperation(c9911218.setop)
	c:RegisterEffect(e3)
end
function c9911218.accon(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9911218.aclimit(e,re,tp)
	local c=re:GetHandler()
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsLocation(LOCATION_SZONE)) or c:IsLocation(LOCATION_GRAVE)
end
function c9911218.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911218.setcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911218.filter,tp,LOCATION_MZONE,0,nil)
	return #g>0 and #g==g:FilterCount(Card.IsType,nil,TYPE_TUNER)
end
function c9911218.setfilter(c)
	local b1=c:IsLocation(LOCATION_HAND) and c:IsSSetable()
	local b2=c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true)
	local b3=c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x5958) and c:IsSSetable()
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and (b1 or b2 or b3)
end
function c9911218.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911233)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if fe then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c9911218.setfilter,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911218,0x5958,TYPES_NORMAL_TRAP_MONSTER,200,400,2,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911218.setop(e,tp,eg,ep,ev,re,r,rp)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911233)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if fe then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c9911218.setfilter,tp,loc,0,1,1,nil):GetFirst()
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
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9911218,0x5958,TYPES_NORMAL_TRAP_MONSTER,200,400,2,RACE_AQUA,ATTRIBUTE_WATER) then
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
		and Duel.SelectYesNo(tp,aux.Stringid(9911218,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		Duel.SynchroSummon(tp,g:GetFirst(),nil)
	end
end
