--人理之诗 眩目的闪光魔盾
function c22023640.initial_effect(c)
	aux.AddCodeList(c,22023340,22023540)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,22023640)
	e1:SetCondition(c22023640.condition)
	e1:SetTarget(c22023640.target)
	e1:SetOperation(c22023640.activate)
	c:RegisterEffect(e1)
	--o do to ha
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021160,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,22023641)
	e2:SetCondition(c22023640.condition2)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c22023640.odthop)
	c:RegisterEffect(e2)
end
function c22023640.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon(e,tp,eg,ep,ev,re,r,rp)
		and Duel.GetFlagEffect(tp,22023340)
end
function c22023640.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c22023640.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023640.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c22023640.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc and Duel.GetFlagEffect(tp,22023340)>2 do
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c22023640.cfilter2(c)
	return c:IsFaceup() and c:IsCode(22023540)
end
function c22023640.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023640.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023640.odthop(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
end