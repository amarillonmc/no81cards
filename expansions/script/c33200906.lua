--寒霜灵兽 极光幕
function c33200906.initial_effect(c)
	c:SetUniqueOnField(1,0,33200906)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33200906.condition)
	e1:SetTarget(c33200906.target)
	c:RegisterEffect(e1)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c33200906.indtg)
	e0:SetValue(c33200906.indct)
	c:RegisterEffect(e0)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c33200906.rdtg)
	e5:SetValue(HALF_DAMAGE)
	c:RegisterEffect(e5)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200906,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200906.counttg)
	e2:SetOperation(c33200906.counter)
	c:RegisterEffect(e2)
end

--Activate
function c33200906.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200900)>0
end
function c33200906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33200906.descon)
	e1:SetOperation(c33200906.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(33200906,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,5)
	c33200906[e:GetHandler()]=e1
end
function c33200906.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c33200906.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(m)
	end
end

--e0
function c33200906.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x332a) and c:IsType(TYPE_MONSTER)
end
function c33200906.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c33200906.rdtg(e,c)
	return c:IsSetCard(0x332a)
end

--e2
function c33200906.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x132a)
end
function c33200906.counter(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33200906,nil,EFFECT_FLAG_OATH,1)
	local fc=Duel.GetFlagEffect(tp,33200906)+2
	if fc>0 and e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x132a,fc)
	end
end