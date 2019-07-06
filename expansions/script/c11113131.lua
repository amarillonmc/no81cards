--智商扭曲？
function c11113131.initial_effect(c)
	c:SetUniqueOnField(1,1,11113131)
    c:EnableCounterPermit(0x4)
	c:SetCounterLimit(0x4,5)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c11113131.activate)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c11113131.econ1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c11113131.econ2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e5)
	if not c11113131.global_check then
		c11113131.global_check=true
		c11113131[0]=0
		c11113131[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c11113131.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c11113131.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c11113131.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p=tc:GetSummonPlayer()
    c11113131[p]=c11113131[p]+1
end
function c11113131.clear(e,tp,eg,ep,ev,re,r,rp)
	c11113131[0]=0
	c11113131[1]=0
end
function c11113131.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c11113131[tp]
	if ct<5 then
	    local t={}
		for i=1,6-ct do t[i]=i+(ct-1) end
		local at=Duel.AnnounceNumber(tp,table.unpack(t))
		if at==0 then return end
		c:AddCounter(0x4,at)
	else
	    c:AddCounter(0x4,5)
	end
end
function c11113131.econ1(e)
    local tp=e:GetHandlerPlayer()
	local st=c11113131[tp]
	return st>=e:GetHandler():GetCounter(0x4)
end
function c11113131.econ2(e)
    local tp=e:GetHandlerPlayer()
	local st=c11113131[1-tp]
	return st>=e:GetHandler():GetCounter(0x4)
end