--那电光普照的未来天堂
local m=33701448
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x46e,LOCATION_FZONE)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.ctcon1)
	e2:SetOperation(cm.ctop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.ctcon2)
	e3:SetOperation(cm.ctop2)
	c:RegisterEffect(e3)
	--Effect 3 buff+
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(cm.bfcon)
	e4:SetTarget(cm.infilter)
	e4:SetValue(1)
	e4:SetLabel(3)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTargetRange(LOCATION_ONFIELD,0)
	e12:SetCondition(cm.bfcon)
	e12:SetTarget(cm.infilter)
	e12:SetValue(aux.tgoval)
	e12:SetLabel(5)
	c:RegisterEffect(e12)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_IMMUNE_EFFECT)
	e14:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e14:SetRange(LOCATION_FZONE)
	e14:SetTargetRange(LOCATION_ONFIELD,0)
	e14:SetCondition(cm.bfcon)
	e14:SetTarget(cm.infilter)
	e14:SetValue(cm.efilter)
	e14:SetLabel(7)
	c:RegisterEffect(e14)
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e15:SetRange(LOCATION_FZONE)
	e15:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e15:SetCountLimit(1)
	e15:SetCondition(cm.drcon)
	e15:SetOperation(cm.drop)
	c:RegisterEffect(e15)
	--Effect 4 
	local e34=Effect.CreateEffect(c)
	e34:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e34:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e34:SetCode(EFFECT_DESTROY_REPLACE)
	e34:SetRange(LOCATION_FZONE)
	e34:SetTarget(cm.reptg)
	c:RegisterEffect(e34)
	local e36=Effect.CreateEffect(c)
	e36:SetType(EFFECT_TYPE_SINGLE)
	e36:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e36:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e36:SetCondition(cm.rmcon)
	e36:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e36)
end
--Effect 1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.rev)
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then
		ct=2
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e1,tp)
end
function cm.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0
end
--Effect 2
function cm.cfilter(c,tp)
	return c:GetReasonPlayer()==1-tp
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:FilterCount(cm.cfilter,nil,tp)
	if g>0 then
		c:AddCounter(0x46e,g)
	end
end
function cm.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return de and dp~=tp and rp==tp
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x46e,1)
end
--Effect 3 buff+
function cm.bfcon(e)
	local c=e:GetHandler()
	return c:GetCounter(0x46e)>=e:GetLabel()
end
function cm.infilter(e,c)
	return c~=e:GetHandler()	
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=p and c:GetCounter(0x46e)>=10 
		and Duel.IsPlayerCanDraw(p,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandlerPlayer()
	if Duel.SelectYesNo(p,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
--Effect 4 
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46e)
	if chk==0 then return not c:IsReason(REASON_REPLACE) 
		and c:IsCanRemoveCounter(tp,0x46e,7,REASON_EFFECT) end
	c:AddCounter(0x46e,ct)
	c:RemoveCounter(tp,0x46e,14,REASON_EFFECT+REASON_REPLACE)
	return true
end
function cm.rmcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_FZONE) 
		and c:IsReason(REASON_DESTROY)
end
