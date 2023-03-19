--奔跃的韶光 栗生茜
function c9910458.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9910458)
	e1:SetCondition(c9910458.spcon)
	e1:SetCost(c9910458.spcost)
	e1:SetTarget(c9910458.sptg)
	e1:SetOperation(c9910458.spop)
	c:RegisterEffect(e1)
end
function c9910458.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9950)
end
function c9910458.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910458.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,e:GetHandler(),9910458)
end
function c9910458.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	local fid=c:GetFieldID()
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910458,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910458.retcon)
		e1:SetOperation(c9910458.retop)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(9910458,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end
function c9910458.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(9910458)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910458.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c9910458.spfilter(c,e,tp,zone)
	return c:IsCode(9910458) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c9910458.seqfilter(c,tp,seq)
	if not c:IsCanAddCounter(0x1950,1) then return false end
	if c:IsControler(1-tp) and c:GetSequence()<5 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 then
		if c:IsControler(1-tp) then cseq=11-cseq end
		return seq==1 and cseq==5 or seq==3 and cseq==6
	end
	return cseq==seq or cloc==LOCATION_MZONE and math.abs(cseq-seq)==1
end
function c9910458.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	for i=0,4 do
		if Duel.IsExistingMatchingCard(c9910458.seqfilter,tp,LOCATION_ONFIELD,LOCATION_MZONE,1,nil,tp,i) then
			zone=bit.replace(zone,0x1,i)
		end
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910458.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9910458.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local zone=0
	for i=0,4 do
		if Duel.IsExistingMatchingCard(c9910458.seqfilter,tp,LOCATION_ONFIELD,LOCATION_MZONE,1,nil,tp,i) then
			zone=bit.replace(zone,0x1,i)
		end
	end
	local g=Duel.SelectMatchingCard(tp,c9910458.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 and tc:IsOnField() then
		local seq=tc:GetSequence()
		local sg=Duel.GetMatchingGroup(c9910458.seqfilter,tp,LOCATION_ONFIELD,LOCATION_MZONE,tc,tp,seq)
		for sc in aux.Next(sg) do sc:AddCounter(0x1950,1) end
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(9910466,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9910458,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9910458.retcon2)
		e1:SetOperation(c9910458.retop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910458.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910466)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c9910458.retop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
