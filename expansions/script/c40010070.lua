--暗黑的击退者
local m=40010070
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	c:EnableCounterPermit(0x588)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.counter)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_RELEASE_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)  
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)  
end
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(0x5d)*100
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x5d,ct)
	end
end
function cm.repfilter(c,tp)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_HAND)) and cm.Revenger(c) and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local count=eg:FilterCount(cm.repfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x5d,count,REASON_COST)
	end

	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x5d,count,REASON_COST)
end