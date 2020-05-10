--元素英雄 罪新宇侠
function c9950476.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c9950476.uqfilter,LOCATION_MZONE)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(89943723)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950476.spcon)
	e1:SetOperation(c9950476.spop)
	c:RegisterEffect(e1)
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9950476.efilter)
	c:RegisterEffect(e1)
  --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950476,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(c9950476.thcost)
	e2:SetTarget(c9950476.thtg)
	e2:SetOperation(c9950476.thop)
	c:RegisterEffect(e2)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c9950476.descon)
	c:RegisterEffect(e2)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950476.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950476.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950476,0))
end
function c9950476.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115) then
		return c:IsCode(9950476)
	else
		return c:IsSetCard(0x23)
	end
end
function c9950476.spfilter(c)
	return c:IsSetCard(0x9) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950476.spfilter2(c,tp)
	return c:IsHasEffect(48829461,tp) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9950476.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950476.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	return b1 or b2
end
function c9950476.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950476.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(48829461,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950476.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		local te=tg:GetFirst():IsHasEffect(48829461,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950476.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c9950476.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9950476.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c9950476.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9950476.thfilter(c)
	return ((c:IsSetCard(0xf6) and c:IsType(TYPE_FIELD)) or(c:IsSetCard(0x23)and c:IsType(TYPE_SPELL)) or c:IsCode(42015635)) and c:IsAbleToHand()
end
function c9950476.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950476.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950476.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950476.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
