--奥特兄弟·佐菲
function c9951534.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951534,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9951534)
	e1:SetTarget(c9951534.sptg)
	e1:SetOperation(c9951534.spop)
	c:RegisterEffect(e1)
 --atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9bd1))
	e3:SetValue(c9951534.atkval)
	c:RegisterEffect(e3)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951534,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9951534.cost)
	e3:SetTarget(c9951534.target)
	e3:SetOperation(c9951534.activate)
	c:RegisterEffect(e3)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951534,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9951534.etcon)
	e3:SetCost(c9951534.cost)
	e3:SetTarget(c9951534.target)
	e3:SetOperation(c9951534.activate)
	c:RegisterEffect(e3)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951534.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951534.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951534,0))
end
function c9951534.spfilter(c,e,tp)
	return c:IsSetCard(0x9bd1) and (c:IsType(TYPE_XYZ) or c:IsLevelAbove(5)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951534.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9951534.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9951534.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9951534.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9951534.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951534.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x9bd1) or c:IsAttribute(ATTRIBUTE_LIGHT))
end
function c9951534.atkval(e,c)
	return Duel.GetMatchingGroupCount(c9951534.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c9951534.costfilter(c)
	return (c:IsSetCard(0x9bd1) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToRemoveAsCost()
end
function c9951534.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c9951534.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951534.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9951534.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951534.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9951534.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951534,1))
end

