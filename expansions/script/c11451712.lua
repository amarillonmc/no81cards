--绛胧烈刃·吸收频谱
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451711,4))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetCondition(cm.recon)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.mrcon)
	e3:SetTarget(cm.mrtg)
	e3:SetOperation(cm.mrop)
	c:RegisterEffect(e3)
end
function cm.ccfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0 --Duel.GetMatchingGroupCount(cm.ccfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,tp)==0
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local t={}
	local i=1
	for i=1,7 do t[i]=i+2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_MOVE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e2:SetCondition(cm.mvcon)
		e2:SetOperation(cm.mvop1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		e:UseCountLimit(tp,1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
		c:RegisterFlagEffect(11451717,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(11451717,ct-3))
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,9-ct,aux.Stringid(11451718,9-ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(c:GetFieldID())
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(11451718)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=9 then
		c:ResetFlagEffect(11451718)
		Duel.ReturnToField(c)
		e:Reset()
	else
		flag=flag+1
		c:ResetFlagEffect(11451718)
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451718,flag))
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:GetFlagEffect(11451717)>0
end
function cm.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local n=11451718
	local cn=_G["c"..n]
	local chk=false
	local c=e:GetHandler()
	local lab=c:GetFlagEffectLabel(11451717)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		if cm.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) and not chk then
			ops[off]=aux.Stringid(n,10)
			opval[off-1]=1
			off=off+1
		end
		for i=11451711,11451715 do
			local ci=_G["c"..i]
			if ci and cn and cn[i] and Duel.GetFlagEffect(tp,0xffffff+i)==0 and ci.mvop and ci.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) then
				ops[off]=aux.Stringid(i,3)
				opval[off-1]=i-11451709
				off=off+1
			end
		end
		if off==1 then break end
		ops[off]=aux.Stringid(n,11)
		opval[off-1]=7
		--mobile adaption
		local ops2=ops
		local op=-1
		if off<=5 then
			op=Duel.SelectOption(tp,table.unpack(ops))
		else
			local page=0
			while op==-1 do
				if page==0 then
					ops2={table.unpack(ops,1,4)}
					table.insert(ops2,aux.Stringid(11451505,4))
					op=Duel.SelectOption(tp,table.unpack(ops2))
					if op==4 then op=-1 page=1 end
				else
					ops2={table.unpack(ops,5,off)}
					table.insert(ops2,1,aux.Stringid(11451505,3))
					op=Duel.SelectOption(tp,table.unpack(ops2))+3
					if op==3 then op=-1 page=0 end
				end
			end
		end
		if opval[op]==1 then
			cm.mvop(e,tp,eg,ep,ev,re,r,rp,0,lab)
			chk=true
		elseif opval[op]>=2 and opval[op]<=6 then
			local ci=_G["c"..opval[op]+11451709]
			ci.mvop(e,tp,eg,ep,ev,re,r,rp,1,lab)
		elseif opval[op]==7 then break end
	end
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
function cm.gradient(y,x)
	if y~=0 and x==0 then return math.pi/2 end
	if x*y>=0 and x~=0 then return math.atan(y/x) end
	if x*y<0 and x~=0 then return math.pi+math.atan(y/x) end
	return 1000
end
function cm.direction(c,lc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(lc,tp)
	return cm.gradient(y2-y1,x2-x1)
end
function cm.fselect(g,c)
	local tc=g:GetFirst()
	if not tc then return false end
	local i=1
	if tc==c then
		i=i+1
		tc=g:GetNext()
	end
	if not tc then return true end
	local dir=cm.direction(tc,c,0)
	while i<#g do
		i=i+1
		tc=g:GetNext()
		if tc~=c and dir~=cm.direction(tc,c,0) then return false end
	end
	return true --g:GetClassCount(cm.direction,c,0)==1 or (g:IsContains(c) and #g>1 and g:GetClassCount(cm.direction,c,0)==2)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,opt,lab)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local b1=0
	local fid=e:GetLabel()
	if fid~=0 then b1=1 end
	if ct<lab then
		if opt==2 then return true end
		if not c:IsLocation(LOCATION_MZONE) then return end
		Duel.HintSelection(Group.FromCards(c))
		--if Duel.SelectYesNo(tp,aux.Stringid(m,4+b1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=g2:SelectSubGroup(tp,cm.fselect,false,1,5,c)
			--if tg and #tg>0 then Duel.HintSelection(tg) end
			Duel.Destroy(tg,REASON_EFFECT)
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
		--end
	elseif ct>=lab and g and #g>0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		--if Duel.SelectYesNo(tp,aux.Stringid(m,b1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=g:Select(tp,1,1,nil)
			Duel.Destroy(tg,REASON_EFFECT)
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
		--end
	end
	--c:ResetFlagEffect(11451717)
end
function cm.cfilter(c)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.mrcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.mrop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end