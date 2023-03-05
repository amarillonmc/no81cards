--治安战警队-虹移执行者
local s,id,o=GetID()

S_Force_disable_field=true

function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.discon)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x156)
end
function s.cfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.cfilter(c,tp)
	local cg=c:GetColumnGroup()
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) and cg:IsExists(s.cfilter2,1,nil,tp)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	S_Force_disable_field=false
	local dg=eg:Filter(s.cfilter,nil,tp)
	if #dg>0 then
		local tc=dg:GetFirst()
		local zone=0
		while tc do
			local val=aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,tc:GetSequence())
			zone=zone|val
			tc=dg:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(zone)
		Duel.RegisterEffect(e1,tp)
	end
	S_Force_disable_field=true
end
function s.zonecheck(tp)
	local zone=0
	for i=0,4 do 
		if i~=0 then
			if i~=4 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(i-1)))>0 or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(i+1)))>0 then zone=zone|(1<<(i)) end
			else
				if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(i-1)))>0 then zone=zone|(1<<(i)) end
			end
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(i+1)))>0 then zone=zone|(1<<(i)) end
		end
	end
	return zone
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.filter(c,e,tp,zone)
	return c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=s.zonecheck(tp)
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local zone=s.zonecheck(tp)
	if zone~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
			local mzone=0
			local seq=g:GetFirst():GetSequence()
			if seq~=0 then
				if seq~=4 then
					if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(seq-1)))>0 then
						mzone=mzone|(1<<(seq-1))
					end
					if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(seq+1)))>0 then
						mzone=mzone|(1<<(seq+1))
					end
				else
					if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(seq-1)))>0 then
						mzone=mzone|(1<<(seq-1))
					end
				end
			else
				if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(seq+1)))>0 then
					mzone=mzone|(1<<(seq+1))
				end
			end
			if mzone~=0 then
				local flag=bit.bxor(mzone,0xff)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
				Duel.Hint(HINT_ZONE,tp,fd)
				local seq=math.log(fd,2)
				Duel.MoveSequence(e:GetHandler(),seq)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
