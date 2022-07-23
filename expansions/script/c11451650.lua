--将军刽子手
--22.05.06
local m=11451650
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.immcon)
	e1:SetValue(cm.immval)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e0)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.distarget)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(cm.distarget)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.descon)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	--move
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e6:SetCondition(cm.stcon)
	e6:SetTarget(cm.sttg)
	e6:SetOperation(cm.stop)
	c:RegisterEffect(e6)
end
function cm.lcheck(g)
	return g:GetSum(Card.GetAttack)>=4800
end
function cm.immcon(e)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m)
	return (not flag or flag<3)
end
function cm.immval(e,te_or_c)
	local res=aux.GetValueType(te_or_c)~="Effect" or (te_or_c:IsActivated() and te_or_c:GetOwner()~=e:GetHandler())
	if res then
		if aux.GetValueType(te_or_c)=="Effect" then Duel.Hint(HINT_CARD,0,m) end
		local c=e:GetHandler()
		local flag=c:GetFlagEffectLabel(m)
		if flag then
			flag=flag+1
			c:ResetFlagEffect(m)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(m,flag+3))
		else
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(m,4))
		end
	end
	return res
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.seqfilter(c,tc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	return math.abs(y1-y2)<=1 and math.abs(x1-x2)==1
end
function cm.distarget(e,c)
	return (c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0) and cm.seqfilter(c,e:GetHandler(),0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and cm.seqfilter(re:GetHandler(),e:GetHandler(),0) then
		Duel.NegateEffect(ev)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler(),tp)
	return #g>0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler(),tp)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m+1)
	return re:GetHandler()~=c and tp==c:GetOwner() and (not flag or flag<3)
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m+1)
	if flag then
		flag=flag+1
		c:ResetFlagEffect(m+1)
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(m,flag+6))
	else
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(m,7))
	end
end
function cm.GetCardsInZone(tp,fd)
	if fd&0x400020>0 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd&0x200040>0 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
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
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=c:GetLinkedZone(tp)
	local seq=c:GetSequence()
	if seq<5 then
		local fd=0
		if zone&0x600060>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local off=1
			local ops,opval={},{}
			if zone&0x400020>0 and ((c:IsControler(tp) and Duel.GetFieldCard(tp,LOCATION_MZONE,6)==nil) or (c:IsControler(1-tp) and Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)==nil)) then
				ops[off]=aux.Stringid(m,1)
				opval[off]=0
				off=off+1
			end
			if zone&0x200040>0 and ((c:IsControler(tp) and Duel.GetFieldCard(tp,LOCATION_MZONE,5)==nil) or (c:IsControler(1-tp) and Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)==nil)) then
				ops[off]=aux.Stringid(m,2)
				opval[off]=1
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))+1
			local sel=opval[op]
			if sel==0 then fd=0x400020 else fd=0x200040 end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			fd=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,(0x600060|(~zone)))
		end
		local tc=cm.GetCardsInZone(tp,fd)
		if tc then Duel.Destroy(tc,REASON_RULE) end
		local nseq=math.log(fd,2)
		if c:IsControler(tp) then
			if fd==0x400020 then nseq=5 elseif fd==0x200040 then nseq=6 end
		else
			if fd==0x400020 then nseq=6 elseif fd==0x200040 then nseq=5 end
		end
		if nseq<16 then Duel.MoveSequence(c,nseq) else Duel.MoveSequence(c,nseq-16) end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~zone)
		local tc=cm.GetCardsInZone(tp,fd)
		if tc then Duel.Destroy(tc,REASON_RULE) end
		local nseq=math.log(fd,2)
		if c:IsControler(tp) then
			if nseq<16 then Duel.MoveSequence(c,nseq) else Duel.GetControl(c,1-tp,0,0,1<<(nseq-16)) end
		else
			if nseq<16 then Duel.GetControl(c,tp,0,0,1<<nseq) else Duel.MoveSequence(c,nseq-16) end
		end
	end
end