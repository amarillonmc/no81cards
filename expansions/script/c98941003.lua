--多元春化精的花冠
function c98941003.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xa182)
	c:RegisterEffect(e2)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(98941003)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--tofiled
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c98941003.damop)
	c:RegisterEffect(e5)
end
function c98941003.cfilter(c)
	return c:IsCode(98941003) and c:IsFaceup()
end
function c98941003.csfilter(c)
	return c:IsCode(98941006)
end
function c98941003.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c98941003.csfilter,nil,tp)>0 and not Duel.IsExistingMatchingCard(c98941003.cfilter,tp,LOCATION_SZONE,0,1,nil) then
	   Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end