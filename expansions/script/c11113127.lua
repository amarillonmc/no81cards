--智商碾压！？
function c11113127.initial_effect(c)
    c:SetUniqueOnField(1,1,11113127)
    c:EnableCounterPermit(0x4)
	c:SetCounterLimit(0x4,5)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c11113127.activate)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c11113127.econ1)
	e2:SetValue(c11113127.actlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(c11113127.econ2)
	c:RegisterEffect(e3)
	if not c11113127.global_check then
		c11113127.global_check=true
		c11113127[0]=0
		c11113127[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11113127.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c11113127.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c11113127.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c11113127.checkop1(e,tp,eg,ep,ev,re,r,rp)
	c11113127[ep]=c11113127[ep]+1
end
function c11113127.checkop2(e,tp,eg,ep,ev,re,r,rp)
	c11113127[ep]=c11113127[ep]-1
end
function c11113127.clear(e,tp,eg,ep,ev,re,r,rp)
	c11113127[0]=0
	c11113127[1]=0
end
function c11113127.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c11113127[tp]
	if ct<5 then
	    local t={}
	    for i=1,6-ct do t[i]=i+(ct-1) end
		local at=Duel.AnnounceNumber(tp,table.unpack(t))
		c:AddCounter(0x4,at)
	else
	    c:AddCounter(0x4,5)
	end
end
function c11113127.econ1(e)
    local tp=e:GetHandlerPlayer()
	local st=c11113127[tp]
	return st>=e:GetHandler():GetCounter(0x4)
end
function c11113127.econ2(e)
    local tp=e:GetHandlerPlayer()
	local st=c11113127[1-tp]
	return st>=e:GetHandler():GetCounter(0x4)
end
function c11113127.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end