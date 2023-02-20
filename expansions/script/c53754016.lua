local m=53754016
local cm=_G["c"..m]
cm.name="异冽玉尘阁"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADD_COUNTER+0x153d)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetLabelObject(c)
	e3:SetOperation(cm.regop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0xff,0xff)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetCondition(cm.tempcon)
	e5:SetValue(cm.efilter2)
	c:RegisterEffect(e5)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e5:SetLabelObject(sg)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetValue(cm.efilter1)
	e6:SetLabelObject(e5)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_ONFIELD,0)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetLabelObject(e6)
	e7:SetCondition(cm.tempcon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EVENT_LEAVE_FIELD_P)
	e8:SetRange(LOCATION_FZONE)
	e8:SetOperation(cm.checkop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1)
	e9:SetLabelObject(e8)
	e9:SetCondition(cm.pcon)
	e9:SetTarget(cm.ptg)
	e9:SetOperation(cm.pop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_CHAIN_SOLVING)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetOperation(cm.solving)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_CHAIN_SOLVED)
	e11:SetRange(LOCATION_FZONE)
	e11:SetOperation(cm.solved)
	c:RegisterEffect(e11)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e
end
function cm.ctfilter(c)
	return c:GetCounter(0x153d)==0 and c:IsCanAddCounter(0x153d,1) and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED+STATUS_LEAVE_CONFIRMED)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,m)
	for i=1,ev do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then tc:AddCounter(0x153d,1) else break end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetLabelObject(),EVENT_CUSTOM+m,re,0,0,0,ev)
end
function cm.tempcon(e)
	return not cm.chain_solving
end
function cm.efilter1(e,te)
	local tp=e:GetHandlerPlayer()
	local res=te:GetOwnerPlayer()~=tp and te:IsActivated()
	if not res then
		local se=e:GetLabelObject()
		if not se then return false end
		local tc=se:GetHandler()
		local e1=se:Clone()
		se:Reset()
		tc:RegisterEffect(e1,true)
		e:SetLabelObject(e1)
		return false
	end
	if e:GetHandler():GetFlagEffect(m+50)>0 then return false end
	if not e:GetLabelObject() then return false end
	local sg=e:GetLabelObject():GetLabelObject()
	local ct=0
	for i=1,99 do if te:GetHandler():IsCanRemoveCounter(tp,0x153d,i,REASON_EFFECT) then ct=ct+1 else break end end
	e:GetLabelObject():SetLabel(ct)
	if sg:IsContains(e:GetHandler()) then
		Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,0)
		sg:Clear()
	end
	sg:AddCard(e:GetHandler())
	sg:AddCard(te:GetHandler())
	return false
end
function cm.efilter2(e,te)
	local tp=e:GetHandlerPlayer()
	local sg=e:GetLabelObject()
	if #sg==0 then return false end
	if te:GetOwnerPlayer()==tp or not te:IsActivated() then return false end
	local ct=0
	for tc in aux.Next(sg) do
		if tc~=te:GetHandler() then for i=1,24 do if tc:IsCanRemoveCounter(tp,0x153d,i,REASON_EFFECT) then ct=ct+1 else break end end end
	end
	local le={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(le) do
		v:GetLabelObject():Reset()
		v:Reset()
	end
	local label=e:GetLabel()+ct
	if Duel.GetFlagEffect(tp,m)==0 then label=114514 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabel(label)
	e1:SetLabelObject(e)
	e1:SetOperation(cm.imcop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	return true
end
function cm.sfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and (c:IsCanRemoveCounter(tp,0x153d,1,REASON_EFFECT) or c:IsControler(tp))
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,m)
	local g=e:GetLabelObject():GetLabelObject()
	local ct=g:GetCount()-1
	if e:GetLabel()<114514 then
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:FilterSelect(tp,cm.sfilter,1,1,nil,tp):GetFirst()
		if not tc then break end
		local res1=tc:IsCanRemoveCounter(tp,0x153d,1,REASON_EFFECT)
		local res2=tc:IsControler(tp)
		local op=0
		if res1 and res2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),1191) elseif res1 then op=0 elseif res2 then op=1 else break end
		if op==0 then tc:RemoveCounter(tp,0x153d,1,REASON_EFFECT) else Duel.SendtoGrave(tc,REASON_RULE) end
		ct=ct-1
	end
	end
	Duel.ResetFlagEffect(tp,m)
	g:Clear()
	e:Reset()
end
function cm.cfilter(c)
	return c:GetCounter(0x153d)>0 and c:GetReasonPlayer()~=tp
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil) then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function cm.pfilter(c,tp)
	return c:GetType()&0x20004==0x20004 and c:IsSetCard(0xc533) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function cm.solving(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	for tc in aux.Next(g) do
		local le={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
		for _,v in pairs(le) do
			local val=v:GetValue()
			if not val or val(v,re) then
				tc:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
				break
			end
		end
	end
	cm.chain_solving=false
end
function cm.solved(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	g:ForEach(Card.ResetFlagEffect,m)
end
