--奥菲以诺之王
function c9981245.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9bca))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
 --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9981245.atkcon)
	e2:SetValue(c9981245.atkval)
	c:RegisterEffect(e2)
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981245,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9981245)
	e2:SetCost(c9981245.spcost)
	e2:SetTarget(c9981245.sptg)
	e2:SetOperation(c9981245.spop)
	c:RegisterEffect(e2)
 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981245,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,99812450)
	e2:SetCondition(c9981245.thcon2)
	e2:SetTarget(c9981245.thtg2)
	e2:SetOperation(c9981245.thop2)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981245.sumsuc)
	c:RegisterEffect(e8)
end
function c9981245.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981245,0)) 
end 
function c9981245.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c9981245.atkval(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE)*400
end
function c9981245.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c9981245.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9981245.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9981245.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9981245.spfilter(c,e,tp)
	return c:IsSetCard(0x9bca) and c:IsType(TYPE_RITUAL) and not c:IsCode(9981245) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9981245.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981245.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981245.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981245.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c9981245.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9981245.thfilter2(c,tp)
	return c:IsSetCard(0x9bca) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9981245.thfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c9981245.thfilter3(c)
	return c:IsSetCard(0x9bca) and c:IsType(TYPE_MONSTER) and not c:IsCode(9981245) and c:IsAbleToHand()
end
function c9981245.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981245.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981245.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9981245.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c9981245.thfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
