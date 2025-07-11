--魔人★双子轮舞
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.chkop)
	c:RegisterEffect(e1)
	--fire
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(11451481)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.con1)
	c:RegisterEffect(e2)
	--water
	local e3=e2:Clone()
	e3:SetCode(11451482)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--hintchk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	--e4:SetCondition(cm.chkcon)
	e4:SetOperation(cm.chkop)
	c:RegisterEffect(e4)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),11451481)<1+e:GetHandler():GetFlagEffect(11451926)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),11451482)<1+e:GetHandler():GetFlagEffect(11451926)
end
function cm.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x97b)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),11451481)<1+e:GetHandler():GetFlagEffect(11451926) then
		if c:GetFlagEffect(11451481)==0 then c:RegisterFlagEffect(11451481,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4)) end
	else
		c:ResetFlagEffect(11451481)
	end
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),11451482)<1+e:GetHandler():GetFlagEffect(11451926) then
		if c:GetFlagEffect(11451482)==0 then c:RegisterFlagEffect(11451482,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5)) end
	else
		c:ResetFlagEffect(11451482)
	end
end