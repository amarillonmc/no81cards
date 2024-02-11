--笑点解析
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reveal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.adcon)
	e3:SetOperation(cm.adop)
	c:RegisterEffect(e3)
	--immune
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_SINGLE)
	ge2:SetCode(EFFECT_IMMUNE_EFFECT)
	ge2:SetRange(LOCATION_ONFIELD)
	ge2:SetLabelObject(c)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetValue(cm.chkval0)
	local ge3=Effect.CreateEffect(c)
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	ge3:SetTargetRange(LOCATION_ONFIELD,0)
	ge3:SetRange(LOCATION_SZONE)
	ge3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetLabelObject(ge2)
	c:RegisterEffect(ge3)
end
function cm.chkval0(e,te)
	local c=e:GetLabelObject()
	local tp=e:GetHandlerPlayer()
	if te and te:IsActivated() then
		local attr=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_ATTRIBUTE) or 0
		local typ=te:GetActiveType()
		if typ&TYPE_SPELL>0 then attr=attr|0x80 end
		if typ&TYPE_TRAP>0 then attr=attr|0x100 end
		for i=0,8 do
			if attr&(1<<i)>0 then
				if c:IsLocation(LOCATION_HAND+LOCATION_SZONE) and c:IsFaceup() then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(m,i))
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(0)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					e1:SetTargetRange(1,0)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
				--immune
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_IMMUNE_EFFECT)
				e2:SetTargetRange(LOCATION_ONFIELD,0)
				e2:SetLabel(1<<i)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetValue(cm.efilter)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
	return false
end
function cm.efilter(e,te)
	if not te:IsActivated() then return false end
	local attr=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_ATTRIBUTE) or 0
	local typ=te:GetActiveType()
	if typ&TYPE_SPELL>0 then attr=attr|0x80 end
	if typ&TYPE_TRAP>0 then attr=attr|0x100 end
	if attr&e:GetLabel()>0 then
		Duel.Hint(HINT_CARD,0,m)
		return true
	end
	return false
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPublic()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,10)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9))
	end
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPublic() and c:GetFlagEffect(m-1)==0 then
		c:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif c:GetFlagEffect(m-1)>0 then
		c:ResetFlagEffect(m-1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,11))
		--immune
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetLabelObject(c)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge2:SetValue(cm.chkval0)
		ge2:SetTargetRange(LOCATION_ONFIELD,0)
		ge2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ge2,tp)
	end
end