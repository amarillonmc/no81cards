--方舟骑士-异客
--21.05.21
local cm,m=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--pendulum summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,nil,cm.lcheck)
	--skill
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x11e0)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.lcheck(g)
	return not g:IsExists(cm.lfilter,1,nil,g)
end
function cm.lfilter(c,g)
	return g:IsExists(cm.lfilter2,1,c,c)
end
function cm.lfilter2(c,tc)
	for i=0,8 do
		if c:IsLinkMarker(1<<i) and tc:IsLinkMarker(1<<i) then return true end
	end
	return false
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
	return Duel.GetFieldCard(p,loc,seq)
end
function cm.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,m)<=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local fd=0
	if (Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)~=nil or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)~=nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local off=1
		local ops,opval={},{}
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)~=nil then
			ops[off]=aux.Stringid(m,4)
			opval[off]=0
			off=off+1
		end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)~=nil then
			ops[off]=aux.Stringid(m,5)
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then fd=0x400020 else fd=0x200040 end
	else
		fd=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,1<<29)
	end
	local tc=cm.GetCardsInZone(tp,fd)
	Duel.Hint(HINT_ZONE,tp,fd)
	Duel.Hint(HINT_ZONE,1-tp,fd>>16)
	Duel.SetTargetParam(fd)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,2)
	if tc then Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,fd) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local fd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_MOVE)
		e1:SetLabel(fd)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local fd=e:GetLabel()
	local tc=cm.GetCardsInZone(tp,fd)
	return tc and eg:IsContains(tc)
end
function cm.desfilter(c,p,loc,seq)
	local seq1=c:GetSequence()
	return aux.GetColumn(c,p)==seq or (c:IsControler(p) and c:IsLocation(loc) and math.abs(seq1-seq)==1 and seq<5 and seq1<5)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local fd=0
	if e:GetType()&EFFECT_TYPE_CONTINUOUS~=0 then
		fd=e:GetLabel()
	else
		fd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	end
	local tc=cm.GetCardsInZone(tp,fd)
	if tc then
		if e:GetType()&EFFECT_TYPE_CONTINUOUS~=0 then Duel.Hint(HINT_CARD,0,m) end
		local p,loc,seq=tc:GetControler(),tc:GetLocation(),tc:GetSequence()
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local sg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,p,loc,seq)
		while #sg>0 do
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
			sg=sg:Select(1-tp,1,1,nil)
			tc=sg:GetFirst()
			p,loc,seq=tc:GetControler(),tc:GetLocation(),tc:GetSequence()
			if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
			sg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,p,loc,seq)
		end
	end
end