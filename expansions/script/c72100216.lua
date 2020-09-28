--魔导书士 苍
function c72100216.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x106e),1,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c72100216.chainop)
	c:RegisterEffect(e2)
end
function c72100216.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x106e) and ep==tp then
		Duel.SetChainLimit(c72100216.chainlm)
	end
end
function c72100216.chainlm(e,rp,tp)
	return tp==rp
end