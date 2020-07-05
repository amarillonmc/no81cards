--危机合约·信号屏蔽
function c79020024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c79020024.mtop)
	c:RegisterEffect(e2)	
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c79020024.distarget)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c79020024.disoperation)
	c:RegisterEffect(e3)
end
function c79020024.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1500) then
		Duel.PayLPCost(tp,1500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c79020024.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c79020024.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():GetControler()~=tp then
		Duel.NegateEffect(ev)
	end
end






