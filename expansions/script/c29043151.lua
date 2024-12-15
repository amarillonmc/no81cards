--方舟骑士团-天火
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,29065532)
	c:EnableReviveLimit()
	--COPY RITUAL SPELL
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.cpcost)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1000)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.seqtg)
	e1:SetOperation(s.seqop)
	c:RegisterEffect(e1)
end
s.kinkuaoi_Akscsst=true
function s.cpfilter(c)
	return c:IsSetCard(0x87af) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function s.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function s.desfilter2(c)
	return c:GetSequence()>=5
end
function s.exmzfilter(c,seq)
	return c:GetSequence()==seq
end
function s.seqfilter(c,seq,tp)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq>=5 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	if c:IsControler(tp) then
		if cseq<5 then return false end
		cseq=11-cseq
	end
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(s.exmzfilter,tp,0,LOCATION_MZONE,1,nil,seq) then
		return seq==5 and cseq==1 or seq==6 and cseq==3
	end
	return cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(s.desfilter2,tp,LOCATION_MZONE,0,1,nil))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29043152,0,TYPES_TOKEN_MONSTER,3000,600,11,RACE_ROCK,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) end
	local filter=0
	for i=0,7 do
		if not Duel.IsExistingMatchingCard(s.seqfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,1,nil,i,tp) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_MZONE,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,seq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,seq,tp)
	if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then
		local token=Duel.CreateToken(tp,29043152)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP,1<<seq)
	end
end