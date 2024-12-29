--集光少女合击
function c51929017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51929017)
	e1:SetTarget(c51929017.target)
	e1:SetOperation(c51929017.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51929018)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c51929017.sptg)
	e2:SetOperation(c51929017.spop)
	c:RegisterEffect(e2)
end
function c51929017.cfilter(c)
	return c:GetSequence()<5 and c:IsSetCard(0x3258) and c:IsFaceup()
end
function c51929017.setfilter(c)
	return c:GetSequence()<5
end
function c51929017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51929017.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c51929017.setfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c51929017.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c51929017.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c51929017.cfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c51929017.setfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		if not tc:IsImmuneToEffect(e) then
			local zone=1<<tc:GetSequence()
			local oc=Duel.GetMatchingGroup(c51929017.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c51929017.spfilter(c,e,tp)
	return c:IsSetCard(0x3258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup()
end
function c51929017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c51929017.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c51929017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51929017.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
