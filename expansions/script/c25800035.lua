--小舰娘-小
function c25800035.initial_effect(c)
			--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800035,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c25800035.spcon)
	e1:SetOperation(c25800035.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25800035,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_DECK)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetOperation(c25800035.lpop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25800035,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,25800035)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c25800035.spcon1)
	e3:SetTarget(c25800035.sptg1)
	e3:SetOperation(c25800035.spop1)
	c:RegisterEffect(e3)
end
function c25800035.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function c25800035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)  then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(25800035,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-----2
function c25800035.cfilter(c,tp)
	return  c:GetControler()==1-tp and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c25800035.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(c25800035.cfilter,nil,tp)
	if  ct>0 and (c:IsFaceup() or c:IsPublic()) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
----3
function c25800035.disfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup() and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c25800035.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c25800035.disfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c25800035.xfilter(c)
	return c:IsXyzSummonable(nil)
end
function c25800035.sfilter(c)
	return c:IsSynchroSummonable(nil)
end
function c25800035.lfilter(c)
	return c:IsLinkSummonable(nil)
end
function c25800035.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25800035.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	   Duel.SpecialSummon(c,nil,tp,tp,false,false,POS_FACEUP)
			local b1=Duel.IsExistingMatchingCard(c25800035.sfilter,tp,LOCATION_EXTRA,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(c25800035.xfilter,tp,LOCATION_EXTRA,0,1,nil)
			local b3=Duel.IsExistingMatchingCard(c25800035.lfilter,tp,LOCATION_EXTRA,0,1,nil)
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(25800035,3)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(25800035,4)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(25800035,5)
				opval[off-1]=3
				off=off+1
			end
			ops[off]=aux.Stringid(25800035,6)
			opval[off-1]=4
			off=off+1
			local op=Duel.SelectOption(tp,table.unpack(ops)) 
			if opval[op]==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c25800035.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SynchroSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c25800035.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.XyzSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c25800035.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.LinkSummon(tp,g:GetFirst(),nil)
			end
	   
end
