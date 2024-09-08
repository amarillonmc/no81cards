--永暗绝望
local m=30005308
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1 
	local e04=Effect.CreateEffect(c)
	e04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e04:SetCode(EVENT_CHAIN_SOLVED)
	e04:SetRange(LOCATION_SZONE)
	e04:SetCondition(cm.econ)
	e04:SetOperation(cm.eop)
	c:RegisterEffect(e04)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.negcon)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(cm.sdcon)
	c:RegisterEffect(e1)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.atop)
		Duel.RegisterEffect(ge1,0)
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge11:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge11,0)
	end
end
--all
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then 
		Duel.RegisterFlagEffect(rc:GetOwner(),m,RESET_PHASE+PHASE_END,0,1)
	end 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalType()&TYPE_TRAP==0 then 
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+m,RESET_PHASE+PHASE_END,0,2)
		end
		tc=eg:GetNext()
	end
end
--Effect 1
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT) 
end
--
function cm.ef(re,ev)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
end
function cm.lf(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local cct=Duel.GetFlagEffect(0,m)+Duel.GetFlagEffect(1,m)
	if cct<5 then
		return cm.ef(re,ev)
	else
		return cm.ef(re,ev) and Duel.IsChainDisablable(ev)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local cct=Duel.GetFlagEffect(0,m)+Duel.GetFlagEffect(1,m)
	local rc=re:GetHandler()
	local ec=e:GetHandler()
	if cct<5 then
		if cm.lf(rc) and rc:IsRelateToEffect(re) then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetCondition(cm.akcon)
			e1:SetOperation(cm.akop)
			e1:SetLabelObject(re)
			Duel.RegisterEffect(e1,tp)
		end
	else
		if Duel.NegateEffect(ev) then
			if cm.lf(rc) and rc:IsRelateToEffect(re) then
				cm.disop(e,tp,rc)
			end
		end
	end
end
function cm.akcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=re:GetHandler()
	return re==te and aux.NegateMonsterFilter(tc) and tc:GetFlagEffect(m+m+m)==0
end
function cm.akop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=re:GetHandler()
	if cm.lf(tc) and tc:IsCanBeDisabledByEffect(e) then 
		cm.disop(e,tp,tc)
		tc:RegisterFlagEffect(m+m+m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	e:Reset()
end
function cm.disop(e,tp,tc)
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end
--Effect 2
function cm.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+m)
	return ct>3
end
