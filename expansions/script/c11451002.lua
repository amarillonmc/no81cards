--白暮
local cm,m=GetID()
function cm.initial_effect(c)
	--hexperus
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.cost)
	c:RegisterEffect(e0)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.recon)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.aclimit)
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	if te~=e then
		e1:SetTarget(cm.aclimit2)
		Duel.RegisterEffect(e1,tp)
		return
	end
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.rsop)
	e2:SetLabelObject(e)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,c)
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	return c:GetFlagEffect(m)>0 and (not te or te~=e:GetLabelObject() or te:GetFieldID()~=e:GetLabelObject():GetFieldID())
end
function cm.aclimit2(e,c)
	return c:GetFlagEffect(m)>0
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if rc:IsOnField() and (te==e:GetLabelObject() or re:IsHasType(EFFECT_TYPE_QUICK_F)) then
		rc:ResetFlagEffect(m)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetLabel(ev)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_CHAIN)
		e2:SetOperation(cm.resetop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ev==e:GetLabel() then rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1)) end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetFlagEffect(1)>0
end
function cm.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local tc=g:Select(1-tp,1,1,nil):GetFirst()
	local b1=tc:IsFaceup() and not tc:IsStatus(STATUS_EFFECT_ENABLED)
	if Duel.Remove(tc,nil,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local fid=c:GetFieldID()
		if b1 then fid=m+fid end
		local og1=Duel.GetOperatedGroup()
		if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		local og=og1:Filter(cm.rffilter,nil)
		if og and #og>0 then
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			if Duel.GetCurrentChain()>1 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_CHAIN_SOLVED)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_CHAIN_NEGATED)
				Duel.RegisterEffect(e2,tp)
			else
				e:SetLabel(fid)
				e:SetLabelObject(og)
				cm.retop(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end
function cm.returntofield(tc)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 or tc:GetFlagEffectLabel(m-1)>m then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m-1)==e:GetLabel()
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil,e) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetCurrentChain()==1 end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	g:DeleteGroup()
	local ft,mg,pft,pmg={},{},{},{}
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	pft[3],pft[4]=0,0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	pmg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_PZONE)
	pmg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_PZONE)
	for i=1,2 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	for i=3,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local ct=math.min(#(mg[i]-pmg[i])+pft[i],ft[i])
			local tg=mg[i]:SelectSubGroup(tp,cm.fselect2,false,ct,ct,pft[i])
			local ptg=tg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
			for tc in aux.Next(ptg) do cm.returntofield(tc) end
			for tc in aux.Next(tg-ptg) do cm.returntofield(tc) end
			sg:Sub(tg)
		elseif #pmg[i]>pft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=pmg[i]:Select(tp,pft[i],pft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
	for tc in aux.Next(psg) do cm.returntofield(tc) end
	for tc in aux.Next(sg-psg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			cm.returntofield(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
end