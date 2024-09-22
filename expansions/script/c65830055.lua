--超乎寻常的压力
function c65830055.initial_effect(c)
	c:SetUniqueOnField(1,0,65830055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65830055.negcon)
	e2:SetOperation(c65830055.negop)
	c:RegisterEffect(e2)
end
function c65830055.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa33) and c:IsType(TYPE_MONSTER)
end
function c65830055.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65830055.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL))
end
function c65830055.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65830055)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end