--引火上身
function c33701326.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33701326.op)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c33701326.damval)
	c:RegisterEffect(e1)
end
function c33701326.damval(e,re,val,r,rp,rc)
	return val*3
end	
function c33701326.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():SetTurnCounter(0)
	--COUNTER
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c33701326.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
end
function c33701326.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetOperation(c33701326.ssop)
	c:RegisterEffect(e1)
	end
end
function c33701326.ssop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.SetLP(1-tp,Duel.GetLP(tp)) 
end






