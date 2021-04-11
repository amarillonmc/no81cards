local m=111102
local cm=_G["c"..m]
cm.name="投蛙问路"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_XYZ) and c:IsRank(4) and c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsType(TYPE_XYZ) and c:IsRank(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>=1 and Duel.GetMatchingGroupCount(cm.mmfilter,1-tp,LOCATION_MZONE,0,nil)<5
end
function cm.mmfilter(c)
	return c:GetSequence()<5
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local c=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ZONE)
--	local zone=Duel.SelectField(tp,1,0,LOCATION_MZONE,nil)
	if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
		local seq=tc:GetSequence()
		local ag=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,tc,tp,seq)
		if ag:GetCount()~=0 then Duel.Destroy(ag,REASON_EFFECT) end
	end
end
function cm.seqfilter(c,tp,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	local cseq=c:GetSequence()
--	if tp==c:GetControler() then cseq=cseq>>16 end
	if tp==c:GetControler() and (cseq==5 and seq==3 or cseq==6 and seq==1) then return true end
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE and tp~=c:GetControler()
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1 and tp~=c:GetControler()
end