--悲叹之律－最强音
function c22050080.initial_effect(c)
	c:EnableCounterPermit(0xfec)
	c:SetCounterLimit(0xfec,5)
	c:SetUniqueOnField(1,0,22050080)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c22050080.ctcon)
	e3:SetOperation(c22050080.acop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c22050080.desreptg)
	e4:SetValue(c22050080.desrepval)
	e4:SetOperation(c22050080.desrepop)
	c:RegisterEffect(e4)
end
function c22050080.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsSetCard(0xff8) and c:IsControler(tp) and e:GetHandler():GetFlagEffect(1)>0
end
function c22050080.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xfec,1)
end
function c22050080.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22050080.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c22050080.repfilter,1,nil,tp)
		and c:IsCanRemoveCounter(tp,0xfec,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c22050080.desrepval(e,c)
	return c22050080.repfilter(c,e:GetHandlerPlayer())
end
function c22050080.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0xfec,1,REASON_EFFECT)
end