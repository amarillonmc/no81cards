--原罪 虹龙-究极宝玉神
function c9950480.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c9950480.uqfilter,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950480.spcon)
	e1:SetOperation(c9950480.spop)
	c:RegisterEffect(e1)
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9950480.efilter)
	c:RegisterEffect(e1)
--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c9950480.descon)
	c:RegisterEffect(e2)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(9950480,1))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9950480.atcost)
	e3:SetOperation(c9950480.atop)
	c:RegisterEffect(e3)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetDescription(aux.Stringid(9950480,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c9950480.tdcost)
	e4:SetTarget(c9950480.tdtg)
	e4:SetOperation(c9950480.tdop)
	c:RegisterEffect(e4)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950480.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950480.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950480,0))
end
function c9950480.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115) then
		return c:IsCode(9950480)
	else
		return c:IsSetCard(0x23)
	end
end
function c9950480.spfilter(c)
	return c:IsSetCard(0x2034) and c:IsAbleToRemoveAsCost()
end
function c9950480.spfilter2(c,tp)
	return c:IsHasEffect(48829461,tp) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9950480.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950480.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950480.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	return b1 or b2
end
function c9950480.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950480.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9950480.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(48829461,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950480.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		local te=tg:GetFirst():IsHasEffect(48829461,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c9950480.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c9950480.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9950480.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c9950480.afilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x1034) or (c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER)) and c:IsAbleToGraveAsCost()
end
function c9950480.atcost(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9950480.afilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
	local g=Duel.GetMatchingGroup(c9950480.afilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c9950480.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950480,0))
end
function c9950480.cfilter(c)
	return c:IsSetCard(0x23,0x1034) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950480.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950480.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9950480.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950480.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9950480.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950480,0))
end
