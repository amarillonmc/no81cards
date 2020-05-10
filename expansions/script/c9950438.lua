--fate·学生会
function c9950438.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9950438.actcona)
	e2:SetValue(c9950438.actlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9950438.actcona)
	c:RegisterEffect(e3)
   --disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK+LOCATION_GRAVE))
	c:RegisterEffect(e3)
end
function c9950438.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) 
end
function c9950438.actcona(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950438.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950438.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end