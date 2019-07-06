--瞬时雨
function c33700924.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700924.cost)
	c:RegisterEffect(e1)   
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c33700924.aclimit)
	c:RegisterEffect(e2) 
	if not c33700924.global_check then
		c33700924.global_check=true
		c33700924.wtf={0}
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)	   
		ge4:SetCode(EVENT_CHAINING)
		ge4:SetOperation(c33700924.checkop2)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge4:Clone()
		ge5:SetCode(EVENT_CHAIN_SOLVED)
		ge5:SetOperation(c33700924.checkop3)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge6:SetOperation(c33700924.reset)
		Duel.RegisterEffect(ge6,0)
	end
end
function c33700924.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function c33700924.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:GetHandler():IsCode(table.unpack(c33700924.wtf))
end

function c33700924.checkop3(e,tp,eg,ep,ev,re,r,rp)
	for k,v in ipairs(c33700924.wtf) do
		if v==re:GetHandler():GetCode() then
		return end
	end
	c33700924.wtf[#c33700924.wtf+1]=re:GetHandler():GetCode()
end
function c33700924.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
	   c33700924.wtf[#c33700924.wtf+1]=re:GetHandler():GetCode()
	end
end
function c33700924.reset(e,tp,eg,ep,ev,re,r,rp)
	c33700924.wtf={0}
end