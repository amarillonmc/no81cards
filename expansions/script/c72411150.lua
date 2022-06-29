--马纳历亚魔导公主·安
function c72411150.initial_effect(c)
	aux.AddCodeList(c,72411020,72411030)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c72411150.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x5729),1,99)
	c:EnableReviveLimit()
	--big spell or big EVENT
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c72411150.target)
	e1:SetOperation(c72411150.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c72411150.spcon)
	e2:SetTarget(c72411150.sptg)
	e2:SetOperation(c72411150.spop)
	c:RegisterEffect(e2)
end
function c72411150.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_NORMAL)
end
function c72411150.filter1(c)
	return c:IsCode(72411020) and c:IsDiscardable(REASON_EFFECT)
end
function c72411150.filter2(c)
	return c:IsCode(72411030) and c:IsDiscardable(REASON_EFFECT)
end
function c72411150.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and	Duel.IsExistingMatchingCard(c72411150.filter1,tp,LOCATION_HAND,0,1,nil) 
	local b2= Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411151,0,0x4011,4000,4000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP)  and Duel.IsExistingMatchingCard(c72411150.filter2,tp,LOCATION_HAND,0,1,nil) 
	if chk==0 then return b1 or b2 end
end
function c72411150.tokentarget(e,c)
	local tp=e:GetHandler():GetControler()
	return c:IsSetCard(0x5729) or (c:GetType()==TYPE_SPELL and Duel.IsPlayerAffectedByEffect(tp,72413440))
end
function c72411150.tokenfilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c72411150.operation(e,tp,eg,ep,ev,re,r,rp)
	 local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and   Duel.IsExistingMatchingCard(c72411150.filter1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411151,0,0x4011,4000,4000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP)  and Duel.IsExistingMatchingCard(c72411150.filter2,tp,LOCATION_HAND,0,1,nil) 
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(tp,aux.Stringid(72411150,1),aux.Stringid(72411150,2))
	elseif b1 then opt=Duel.SelectOption(tp,aux.Stringid(72411150,1))
	elseif b2 then opt=Duel.SelectOption(tp,aux.Stringid(72411150,2))+1
	else return end
	
		if opt==0 then
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			if Duel.DiscardHand(tp,c72411150.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
			Duel.Destroy(sg,REASON_EFFECT)
			end
		elseif opt==1 then
			if Duel.DiscardHand(tp,c72411150.filter2,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then 
			local token=Duel.CreateToken(tp,72411151)
				if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1:SetRange(LOCATION_MZONE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetTargetRange(LOCATION_ONFIELD,0)
					e1:SetTarget(c72411150.tokentarget)
					e1:SetValue(c72411150.tokenfilter)
					token:RegisterEffect(e1)
				end
			Duel.SpecialSummonComplete()
			end
		end
end
function c72411150.spfilter(c,e,tp)
	return c:IsSetCard(0x5729) and c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c72411150.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c72411150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c72411150.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c72411150.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c72411150.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
