--方舟骑士-提丰
c29002369.named_with_Arknight=1
function c29002369.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),c29002369.syf,1)
	c:EnableReviveLimit()
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c29002369.slevel)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(4,29002369)
	e2:SetTarget(c29002369.seqtg)
	e2:SetOperation(c29002369.seqop)
	c:RegisterEffect(e2)
end
function c29002369.syf(c,syc)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return setcard and c:IsSynchroType(TYPE_SYNCHRO)
end
function c29002369.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (6<<16)+lv
end
function c29002369.desfilter(c)
	return c:GetSequence()<5
end
function c29002369.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	return cseq==seq and cloc==loc
end
function c29002369.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29002369.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,29002370)==0 end
	local filter=0
	for i=0,15 do
		if not Duel.IsExistingMatchingCard(c29002369.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	Duel.Hint(HINT_ZONE,1-tp,flag>>16)
	Duel.Hint(HINT_ZONE,tp,flag)
	Duel.Hint(HINT_ZONE,1-tp,flag>>16)
	Duel.Hint(HINT_ZONE,tp,flag)
	Duel.Hint(HINT_ZONE,1-tp,flag>>16)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	Duel.RegisterFlagEffect(tp,29002370,RESET_CHAIN,0,1)
end
function c29002369.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,29002369,RESET_PHASE+PHASE_END,0,1)
	local seq=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c29002369.desop)
	e1:SetLabel(Duel.GetFlagEffect(tp,29002369),seq)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c29002369.desop(e,tp,eg,ep,ev,re,r,rp)
	local flag,seq=e:GetLabel()
	local g=Duel.GetMatchingGroup(c29002369.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	if Duel.GetFlagEffect(tp,29002369)==flag and g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
