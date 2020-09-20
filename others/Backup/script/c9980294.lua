--第3位魔法少女
function c9980294.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c9980294.counter)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9980294)
	e2:SetCondition(c9980294.condition)
	e2:SetTarget(c9980294.target)
	e2:SetOperation(c9980294.operation)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c9980294.atkval)
	c:RegisterEffect(e3)
end
function c9980294.cfilter0(c)
	return c:IsSetCard(0xd3) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c9980294.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9980294.cfilter0,1,nil) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980294.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc4)
end
function c9980294.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980294.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c9980294.filter(c)
	return c:IsSetCard(0x6bc4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980294.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980294.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980294.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980294.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
function c9980294.atkval(e,c)
	return e:GetHandler():GetCounter(0x1)*-300
end