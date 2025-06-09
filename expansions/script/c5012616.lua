--欧雷尔斯
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAINING)
	e5:SetOperation(s.desop2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(s.desop2)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetOperation(s.desop2)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e8:SetOperation(s.desop2)
	c:RegisterEffect(e8)
end
function s.mfilter(c,xyzc)
	return c:IsLevelAbove(8) and c.MoJin==true --and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --Duel.GetCurrentChain()<1 and 
		e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.desfilter2(c)
	return c:GetSequence()>4
end
function s.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function s.exmzfilter(c,tp,seq)
	local p=c:GetControler()
	local lseq=seq
	if p==tp then lseq=math.abs(seq-4) end
	return c:GetSequence()==lseq
end
function s.seqfilter(c,seq,tp)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local p=c:GetControler()
	if p==tp and c:IsLocation(LOCATION_SZONE) then return false end
	if cseq<5 and p==tp and c:IsLocation(LOCATION_MZONE) then return false end
	if p==tp and cseq<5 and c:IsLocation(LOCATION_MZONE) then 
		cseq=math.abs(cseq-4) 
	elseif p==tp and cseq==5 and c:IsLocation(LOCATION_MZONE) then 
		cseq=6
	elseif p==tp and cseq==6 and c:IsLocation(LOCATION_MZONE) then 
		cseq=5
	end
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(s.exmzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,seq) then
		return seq==5 and cseq==1 or seq==6 and cseq==3
	end
	return cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local filter=0
	for i=0,15 do
		if not Duel.IsExistingMatchingCard(s.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i,tp) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	local seq=math.log(flag>>16,2)
	local ct=Duel.GetMatchingGroupCount(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp)
	if ct<=0 then return end
	if e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil,seq,tp)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Readjust()
	end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) 
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		s.desop(e,tp,eg,ep,ev,re,r,rp)
	end
end