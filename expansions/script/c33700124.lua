--霓火伏击
function c33700124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33700124.damcon)
	e3:SetOperation(c33700124.damop)
	c:RegisterEffect(e3)
end
function c33700124.damcon(e,tp,eg,ep,ev,re,r,rp)
	 return re and re:GetHandler():IsSetCard(0x443) and re:IsActiveType(TYPE_MONSTER)
end
function c33700124.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33700124)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end