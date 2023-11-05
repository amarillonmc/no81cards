--Speedgear SW1-FT
function c31034007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, 31034007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c31034007.spcon)
	c:RegisterEffect(e1)
	 --synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c31034007.sycon)
	e2:SetOperation(c31034007.syop)
	c:RegisterEffect(e2)
end

function c31034007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(Card.IsCode, c:GetControler(), LOCATION_MZONE, 0, 1, nil, 31034001)
end

function c31034007.sycon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return r == REASON_SYNCHRO and c:GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end

function c31034007.syop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31034007, 0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1, true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2)
end