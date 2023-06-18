--放光水晶机巧遗产
function c88100018.initial_effect(c)
	c:SetUniqueOnField(1,0,88100018)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x30ea))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88100018.negcon)
	e4:SetOperation(c88100018.negop)
	c:RegisterEffect(e4)
end
function c88100018.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x30ea)
end
function c88100018.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88100018.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_TRAP)
end
function c88100018.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,88100018)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end