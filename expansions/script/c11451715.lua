--异绛胧烈刃·偏振频谱
local m=11451715
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	e1:SetCondition(cm.recon)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.mvcon)
	e2:SetOperation(cm.mvop1)
	c:RegisterEffect(e2)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
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
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x57e0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),0,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		c:RegisterFlagEffect(m,RESET_EVENT+0x57e0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
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
		local rc=tc:GetReasonEffect():GetOwner() or tc
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
	local ct=lab//3
	--c:ResetFlagEffect(11451717)
	local b1=0
	local fid=e:GetLabel()
	if fid~=0 then b1=1 end
	local chk=false
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g1=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_REMOVED,0,nil)
	if ct>=1 and #g2>0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		if #g1==0 or Duel.SelectYesNo(tp,aux.Stringid(m,b1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g2:Select(tp,1,ct,nil)
			ct=ct-#sg
			chk=true
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
	g1=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_REMOVED,0,nil)
	if ct>=1 and #g1>0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		if not chk or Duel.SelectYesNo(tp,aux.Stringid(m,b1+4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g1:Select(tp,1,ct,nil)
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
			sg:ForEach(cm.returntofield,e)
			Duel.RaiseEvent(sg,m,e,0,0,0,0)
		end
	end
	--[[while ct>=1 do
		local g1=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g=g1+g2
		if #g>0 then Duel.HintSelection(Group.FromCards(c)) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,b1))
		local sc=g:Select(tp,0,1,nil):GetFirst()
		if not sc then break end
		if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
		if g1:IsContains(sc) and (not g2:IsContains(sc) or Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))==0) then
			cm.returntofield(sc,e)
		else
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
		ct=ct-1
	end--]]
	--[[if #g1>0 and ct>0 then
		local ft,pft={},{}
		ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
		ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
		ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		pft[3],pft[4]=0,0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
		if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
		if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
		if g1:CheckSubGroup(cm.fselect,1,ct,tp,ft[1],ft[2],ft[3],ft[4],pft[3],pft[4]) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local sg=g1:SelectSubGroup(tp,cm.fselect,false,0,ct,tp,ft[1],ft[2],ft[3],ft[4],pft[3],pft[4])
			if sg and #sg>0 then
				ct=ct-#sg
				local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
				for tc in aux.Next(psg) do cm.returntofield(tc,e) end
				for tc in aux.Next(sg-psg) do cm.returntofield(tc,e) end
			end
		end
	end--]]
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
end
function cm.desfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.mrcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfilter,1,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3977) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.mrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.ShuffleDeck(tp)
		if c:IsRelateToEffect(e) then
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		end
	end
end