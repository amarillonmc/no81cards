--永远的三日天下
function c33700913.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700913.cost)
	e1:SetTarget(c33700913.target)
	c:RegisterEffect(e1)   
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(function(e) return Duel.GetFlagEffect(e:GetHandlerPlayer(),33700913)<=0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(function(e) return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),33700913)<=0 and Duel.GetTurnPlayer()==1-e:GetHandlerPlayer() end)
	c:RegisterEffect(e4)	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(function(e) return Duel.GetFlagEffect(e:GetHandlerPlayer(),33700913)<=0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e3:SetValue(c33700913.efilter)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetCondition(function(e) return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),33700913)<=0 and Duel.GetTurnPlayer()==1-e:GetHandlerPlayer() end)
	c:RegisterEffect(e5) 
	if c33700913.counter==nil then
		c33700913.counter=true
		c33700913[0]=0
		c33700913[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c33700913.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c33700913.addcount)
		Duel.RegisterEffect(e3,0) 
	end
end
function c33700913.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
end
function c33700913.resetcount(e,tp,eg,ep,ev,re,r,rp)
	if c33700913[0]>0 then Duel.RegisterFlagEffect(0,33700913,RESET_PHASE+PHASE_END,0,1) end
	if c33700913[1]>0 then Duel.RegisterFlagEffect(1,33700913,RESET_PHASE+PHASE_END,0,1) end
	c33700913[0]=0
	c33700913[1]=0
end
function c33700913.addcount(e,tp,eg,ep,ev,re,r,rp)
	c33700913[rp]=c33700913[rp]+1
end
function c33700913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c33700913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(3)
	e1:SetCountLimit(1)
	e1:SetCondition(c33700913.tgcon)
	e1:SetOperation(c33700913.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	e:GetHandler():RegisterEffect(e1)
end
function c33700913.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33700913.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct-1
	e:SetLabel(ct)
	if ct==0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		Duel.Recover(tp,3000,REASON_EFFECT)
	end
end
