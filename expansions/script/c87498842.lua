--U・A・D—胜利堡垒
local m=87498842
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(cm.seqtg)
	e1:SetOperation(cm.seqop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
end
function cm.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function cm.exmzfilter(c,seq)
	return c:GetSequence()==seq
end
function cm.seqfilter(c,seq,tp)
	if not c:IsAbleToGrave() then return false end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(cm.exmzfilter,tp,0,LOCATION_MZONE,1,nil,seq) then
		return seq==5 and cseq==1 or seq==6 and cseq==3
	end
	return cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,15 do
		if not Duel.IsExistingMatchingCard(cm.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i,tp) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spfilter2(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsRankBelow(8) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
