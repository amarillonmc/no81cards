--原罪 希望皇 霍普
function c9950484.initial_effect(c)
	 c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c9950484.uqfilter,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950484.spcon)
	e1:SetOperation(c9950484.spop)
	c:RegisterEffect(e1)
--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c9950484.descon)
	c:RegisterEffect(e2)
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9950484.efilter)
	c:RegisterEffect(e1)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
 --disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950484,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950484.discon)
	e1:SetOperation(c9950484.atkop)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950484.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950484.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950484,0))
end
function c9950484.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115) then
		return c:IsCode(9950484)
	else
		return c:IsSetCard(0x23)
	end
end
function c9950484.spfilter(c)
	return c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c9950484.spfilter2(c,tp)
	return c:IsHasEffect(48829461,tp) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9950484.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950484.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950484.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	return b1 or b2
end
function c9950484.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950484.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950484.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(48829461,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950484.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		local te=tg:GetFirst():IsHasEffect(48829461,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950484.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c9950484.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9950484.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c9950484.discon(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c9950484.spfilter1(c,e,tp)
	return c:IsSetCard(0x107f,0x23,0x54,0x59,0x82,0x8f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950484.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950484.spfilter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950484,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g1:Select(tp,1,1,nil)
			Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end