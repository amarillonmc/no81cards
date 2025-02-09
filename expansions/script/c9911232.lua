--浩瀚生态 急飙之风云
function c9911232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911232,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9911232.tdcon)
	e2:SetTarget(c9911232.tdtg)
	e2:SetOperation(c9911232.tdop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911232)
	e3:SetCondition(c9911232.setcon)
	e3:SetTarget(c9911232.settg)
	e3:SetOperation(c9911232.setop)
	c:RegisterEffect(e3)
end
function c9911232.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9911232.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911232.cfilter,1,nil,tp)
end
function c9911232.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c9911232.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(9911232,2),aux.Stringid(9911232,3))
	elseif g1:GetCount()>0 then
		opt=0
	elseif g2:GetCount()>0 then
		opt=1
	else
		return
	end
	local sg=nil
	if opt==0 then
		sg=g1:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		sg=g2:Select(tp,1,1,nil)
	end
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c9911232.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911232.setcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911232.filter,tp,LOCATION_MZONE,0,nil)
	return #g>0 and #g==g:FilterCount(Card.IsType,nil,TYPE_TUNER)
end
function c9911232.setfilter(c)
	local b1=c:IsLocation(LOCATION_HAND) and c:IsSSetable()
	local b2=c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true)
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and (b1 or b2)
end
function c9911232.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9911232.setfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911232,0x5958,TYPES_NORMAL_TRAP_MONSTER,1700,1300,2,RACE_THUNDER,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911232.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c9911232.setfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_HAND) then
		if Duel.SSet(tp,tc)==0 then return end
	else
		tc:CancelToGrave()
		if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then return end
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local res=false
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9911232,0x5958,TYPES_NORMAL_TRAP_MONSTER,1700,1300,2,RACE_THUNDER,ATTRIBUTE_WIND) then
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
		and Duel.SelectYesNo(tp,aux.Stringid(9911232,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		Duel.SynchroSummon(tp,g:GetFirst(),nil)
	end
end
