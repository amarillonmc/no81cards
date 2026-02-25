--绛胧烈刃·光电频谱
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
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	cm.special_summon=cm.special_summon or {}
	cm.special_summon[c]=e2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e3:SetCountLimit(1)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>=0 and (aux.GetValueType(cm[c])=="Effect" or cm[c]==1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local te=cm[c]
	cm[c]=nil
	if aux.GetValueType(te)=="Effect" and te:GetHandler():IsOnField() then
		local rc=te:GetHandler()
		local sg=Group.FromCards(c,rc)
		sg:KeepAlive()
		c:RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		rc:RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD,0,1)
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(function() c:SetCardTarget(rc) end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e2)
		--destroy
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetLabelObject(sg)
		e4:SetOperation(cm.chkop)
		Duel.RegisterEffect(e4,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetOperation(cm.desop2)
		e3:SetLabelObject(e4)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject():Filter(function(c) return c:GetFlagEffect(m+3)>0 end,nil)
	if #Group.__band(sg,eg)>0 then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=1 then return end
	local sg=e:GetLabelObject():GetLabelObject():Filter(function(c) return c:GetFlagEffect(m+3)>0 end,nil)
	e:GetLabelObject():GetLabelObject():DeleteGroup()
	e:GetLabelObject():Reset()
	e:Reset()
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x3977) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.nfilter(c)
	return cm.special_summon[c] and c:IsSpecialSummonable(0) --c:IsCanBeSpecialSummoned(cm.special_summon[c],0,c:GetControler(),true,true)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if cm[c]==2 or Duel.GetMZoneCount(tp)<=0 or not cm.nfilter(c) then cm[c]=nil return end
	if cm[c]~=1 then
		local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,c)
		if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			for rc in aux.Next(g) do cm[rc]=2 end
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g:AddCard(c)
		local tc=g:GetFirst()
		if #g>0 then tc=g:Select(tp,1,1,nil):GetFirst() end
		if tc~=c then
			g:RemoveCard(c)
			for rc in aux.Next(g) do cm[rc]=2 end
			cm[tc]=1
			cm[c]=nil
			return
		else
			g:RemoveCard(c)
			for rc in aux.Next(g) do cm[rc]=2 end
		end
	end
	if re:GetHandler():IsRelateToEffect(re) then
		cm[c]=re
	else
		cm[c]=1
	end
	if Duel.GetCurrentChain()==1 then
		local sg=Duel.GetMatchingGroup(Card.IsStatus,0,LOCATION_SZONE,LOCATION_SZONE,nil,STATUS_LEAVE_CONFIRMED)
		sg:KeepAlive()
		for tc in aux.Next(sg) do
			tc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		local tde=Effect.CreateEffect(c)
		tde:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		tde:SetCode(EVENT_CHAIN_END)
		tde:SetLabelObject(sg)
		tde:SetOperation(cm.tdop)
		Duel.RegisterEffect(tde,tp)
	end
	Duel.SpecialSummonRule(tp,c,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject():Filter(function(c) return c:GetFlagEffect(m)>0 end,nil)
	for tc in aux.Next(sg) do
		tc:ResetFlagEffect(m)
		tc:SetStatus(STATUS_LEAVE_CONFIRMED,true)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	e:GetLabelObject():DeleteGroup()
	e:Reset()
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
	local rep=c:IsStatus(STATUS_EFFECT_REPLACED)
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		if rep then c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9)) end
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
			ops[off]=aux.Stringid(m,9)
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
function cm.tempfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_TEMPORARY) and c:GetPreviousLocation()&LOCATION_ONFIELD>0
end
function cm.tffilter(c)
	return c:IsFaceup() and cm.tempfilter(c) and c:IsSetCard(0x3977) and cm.retfilter(c)
end
function cm.thfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand() and c:IsSetCard(0x3977)
end
function cm.retfilter(c)
	local p=c:GetPreviousControler()
	local pft=0
	if Duel.CheckLocation(p,LOCATION_PZONE,0) then pft=pft+1 end
	if Duel.CheckLocation(p,LOCATION_PZONE,1) then pft=pft+1 end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return Duel.GetLocationCount(p,LOCATION_MZONE)>0
	elseif c:IsPreviousLocation(LOCATION_FZONE) then
		return true
	elseif c:IsPreviousLocation(LOCATION_PZONE) then
		return pft>0
	else
		return Duel.GetLocationCount(p,LOCATION_SZONE)>0
	end
end
function cm.retfilter2(c,p,loc)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.fselect(sg,tp,ft1,ft2,ft3,ft4,pft3,pft4)
	mg1=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg2=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg3=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg4=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	pmg3=sg:Filter(cm.retfilter2,nil,tp,LOCATION_PZONE)
	pmg4=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_PZONE)
	return #mg1<=ft1 and #mg2<=ft2 and #mg3<=ft3 and #mg4<=ft4 and #pmg3<=pft3 and #pmg4<=pft4
end
function cm.returntofield(tc,e)
	tc:ResetFlagEffect(11451718)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		return
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		local rc=tc
		if tc:GetReasonEffect() then rc=tc:GetReasonEffect():GetOwner() end
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(m)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.retop3)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.retop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,opt,lab)
	local c=e:GetHandler()
	local ct=lab
	local chk=false
	local fid=e:GetLabel()
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if ct>=2 and #g2>0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Group.CreateGroup()
		if #g1==0 or ct<5 then
			sg=g2:Select(tp,1,ct//2,nil)
		else
			sg=g2:CancelableSelect(tp,1,ct//2,nil)
		end
		if sg and #sg>0 then
			ct=ct-#sg*2
			chk=true
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
	g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if ct>=5 and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Group.CreateGroup()
		if not chk then
			sg=g1:Select(tp,1,ct,nil)
		else
			sg=g1:CancelableSelect(tp,1,ct,nil)
		end
		if sg and #sg>0 then
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.RaiseEvent(sg,m,e,0,0,0,0)
		end
	end
end