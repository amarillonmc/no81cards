--方舟骑士-W
local cm,m=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m+1000)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--skill
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+2000)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.spcfilter(c)
	return c:IsCode(29065500) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
	Duel.SetTargetParam(fd)
	Duel.Hint(HINT_ZONE,tp,fd)
	local fd2=fd
	if fd>=1<<16 then fd2=fd>>16 else fd2=fd<<16 end
	Duel.Hint(HINT_ZONE,1-tp,fd2)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tid=Duel.GetTurnCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabel(fd,tid)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(cm.descon2)
	Duel.RegisterEffect(e3,tp)
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local fd,tid=e:GetLabel()
	if Duel.GetFlagEffect(tp,m+tid)>0 then return false end
	local tc=cm.GetCardsInZone(tp,fd)
	local res1,res2,res3=false,false,false
	res1=(tc and eg:IsContains(tc))
	if fd<=0x8 or (fd<=0x80000 and fd>=0x10000) then
		local tc2=cm.GetCardsInZone(tp,fd<<1)
		res2=(tc2 and eg:IsContains(tc2))
	end
	if (fd>=0x2 and fd<=0x10) or (fd<=0x100000 and fd>=0x20000) then
		local tc3=cm.GetCardsInZone(tp,fd>>1)
		res3=(tc3 and eg:IsContains(tc3))
	end
	return res1 or res2 or res3
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local fd,tid=e:GetLabel()
	if Duel.GetFlagEffect(tp,m+tid)>0 then return false end
	local tc=cm.GetCardsInZone(tp,fd)
	local res1,res2,res3=false,false,false
	res1=(tc and tc:IsPreviousLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_SPSUMMON) and eg:IsContains(tc))
	if fd<=0x8 or (fd<=0x80000 and fd>=0x10000) then
		local tc2=cm.GetCardsInZone(tp,fd<<1)
		res2=(tc2 and tc2:IsPreviousLocation(LOCATION_REMOVED) and not tc2:IsReason(REASON_SPSUMMON) and eg:IsContains(tc2))
	end
	if (fd>=0x2 and fd<=0x10) or (fd<=0x100000 and fd>=0x20000) then
		local tc3=cm.GetCardsInZone(tp,fd>>1)
		res3=(tc3 and tc3:IsPreviousLocation(LOCATION_REMOVED) and not tc3:IsReason(REASON_SPSUMMON) and eg:IsContains(tc3))
	end
	return res1 or res2 or res3
end
function cm.desfilter(c,p,loc,seq)
	local seq1=c:GetSequence()
	return aux.GetColumn(c,p)==seq or (c:IsControler(p) and c:IsLocation(loc) and math.abs(seq1-seq)==1 and seq<5 and seq1<5)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local fd,tid=e:GetLabel()
	local g=Group.CreateGroup()
	local tc=cm.GetCardsInZone(tp,fd)
	if tc then g:AddCard(tc) end
	if fd<=0x8 or (fd<=0x80000 and fd>=0x10000) then
		local tc2=cm.GetCardsInZone(tp,fd<<1)
		if tc2 then g:AddCard(tc2) end
	end
	if (fd>=0x2 and fd<=0x10) or (fd<=0x100000 and fd>=0x20000) then
		local tc3=cm.GetCardsInZone(tp,fd>>1)
		if tc3 then g:AddCard(tc3) end
	end
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m+tid,0,0,1)
end