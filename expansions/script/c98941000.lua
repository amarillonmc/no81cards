--多元春化精的花盛
function c98941000.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c98941000.condition)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98941000,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,98941000)
	e3:SetCost(c98941000.spcost)
	e3:SetTarget(c98941000.sptg)
	e3:SetOperation(c98941000.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98941000,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,98942000)
	e4:SetCondition(c98941000.thcon)
	e4:SetTarget(c98941000.thtg)
	e4:SetOperation(c98941000.thop)
	c:RegisterEffect(e4)
	--tofiled
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c98941000.damop)
	c:RegisterEffect(e5)
end
function c98941000.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c98941000.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c98941000.atkfilter,tp,LOCATION_MZONE,0,nil)>=5
end
function c98941000.costfilter(c)
	return c:IsCode(98941008) and c:IsAbleToRemoveAsCost()
end
function c98941000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941000.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98941000.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98941000.filter(c,e,tp)
	return c:IsCode(98941006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98941000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98941000.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98941000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98941000.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98941000.cfilter(c,tp)
	return c:IsSetCard(0xa182) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function c98941000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98941000.cfilter,1,nil,tp)
end
function c98941000.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98941000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c98941000.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98941000.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c98941000.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98941000.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98941000.csfilter(c)
	return c:IsSetCard(0xa182)
end
function c98941000.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c98941000.csfilter,nil,tp)>0 and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil then
	   Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end