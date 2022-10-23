local m=53737012
local cm=_G["c"..m]
cm.name="异赤次元秽魔导 治者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x1)
	aux.AddLinkProcedure(c,cm.matfilter,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.acop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.acop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.namecost)
	e4:SetTarget(cm.nametg)
	e4:SetOperation(cm.nameop)
	c:RegisterEffect(e4)
end
function cm.matfilter(c)
	return c:GetCounter(0x1)>0
end
function cm.acop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and c:GetFlagEffect(1)>0 then
		local g=Group.__add(c,c:GetLinkedGroup()):Filter(Card.IsCanAddCounter,nil,0x1,1)
		for tc in aux.Next(g) do tc:AddCounter(0x1,1) end
	end
end
function cm.acfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function cm.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(cm.acfilter,1,nil) then
		local g=Group.__add(c,c:GetLinkedGroup()):Filter(Card.IsCanAddCounter,nil,0x1,1)
		for tc in aux.Next(g) do tc:AddCounter(0x1,1) end
	end
end
function cm.namecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,8,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,8,REASON_COST)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function cm.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local afilter={TYPE_SPELL,OPCODE_ISTYPE,TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD+TYPE_QUICKPLAY+TYPE_RITUAL,OPCODE_ISTYPE,OPCODE_NOT}
	local codes={}
	for t=1,500 do
		if e:GetHandler():GetFlagEffect(m+t)>0 then table.insert(codes,e:GetHandler():GetFlagEffectLabel(m+t)) else break end
	end
	for i=1,#codes do
		table.insert(afilter,codes[i])
		table.insert(afilter,OPCODE_ISCODE)
		table.insert(afilter,OPCODE_NOT)
	end
	if Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)<8 then
		table.insert(afilter,0x6531)
		table.insert(afilter,OPCODE_ISSETCARD)
		table.insert(afilter,OPCODE_AND)
	end
	for i=1,(#codes)+1 do table.insert(afilter,OPCODE_AND) end
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.namefilter(c,ac)
	return c:GetType()==TYPE_SPELL and c:IsOriginalCodeRule(ac)
end
function cm.nameop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local typ=Duel.ReadCard(ac,CARDDATA_TYPE)
	if typ~=TYPE_SPELL then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local t=c:GetFlagEffect(m)
	c:RegisterFlagEffect(m+t,RESET_EVENT+RESETS_STANDARD,0,0,ac)
	local op1,op2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2)),0
	if op1==0 then op2=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1 elseif op1==2 then op2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) else
		op2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
		if op2==1 then op2=2 end
	end
	if op1==0 or op2==0 then
		local g=Duel.GetMatchingGroup(cm.namefilter,0,0xff,0xff,nil,ac)
		for tc in aux.Next(g) do
			local tc=tc
			local le={tc:GetActivateEffect()}
			for _,te in pairs(le) do
				local e1=te:Clone()
				e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
				local pro,pro2=te:GetProperty()
				pro2=pro2|EFFECT_FLAG2_COF
				e1:SetProperty(pro,pro2)
				local range=te:GetRange()
				if range then e1:SetRange(range) end
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
				e2:SetRange(LOCATION_MZONE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2:SetTargetRange(0xff,0)
				e2:SetCondition(cm.efcon)
				e2:SetTarget(cm.eftg)
				e2:SetLabelObject(e1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_FIELD)
				e5:SetCode(EFFECT_ACTIVATE_COST)
				e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e5:SetRange(LOCATION_MZONE)
				e5:SetTargetRange(1,1)
				e5:SetLabelObject(e1)
				e5:SetCondition(cm.efcon)
				e5:SetTarget(cm.costtg)
				e5:SetOperation(cm.costop)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e5)
			end
		end
	end
	if op1==1 or op2==1 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetLabel(ac)
		e3:SetCondition(cm.rdcon)
		e3:SetOperation(cm.rdop1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
	if op1==2 or op2==2 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetLabel(ac)
		e4:SetCondition(cm.rdcon)
		e4:SetOperation(cm.rdop2)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
end
function cm.efcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.eftg(e,c)
	return c==e:GetLabelObject():GetOwner()
end
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:GetHandler():IsControler(tp)
end
function cm.rdop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.rdop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(cm.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(te)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==e:GetLabelObject() end)
	e1:SetOperation(cm.ready)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetOperation(cm.rsop)
	Duel.RegisterEffect(e2,tp)
end
function cm.ready(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_ACTIVATE_DISABLED,true)
	e:Reset()
end
