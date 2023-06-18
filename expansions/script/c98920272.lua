--真红眼暗钢龙-暗钢
function c98920272.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,74677422,c98920272.mfilter,1,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920272,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920272)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c98920272.spcon)
	e1:SetTarget(c98920272.sptg)
	e1:SetOperation(c98920272.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(98920272,ACTIVITY_SPSUMMON,c98920272.counterfilter)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920272,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920272)
	e3:SetCost(c98920272.spcost)
	e3:SetTarget(c98920272.sptg)
	e3:SetOperation(c98920272.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(98920272,ACTIVITY_SPSUMMON,c98920272.counterfilter)
end
c98920272.material_setcode=0x3b
function c98920272.mfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c98920272.counterfilter(c)
	return c:IsRace(RACE_DRAGON) or not c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920272.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c98920272.spfilter(c,e,tp)
	return (c:IsRace(RACE_DRAGON) or c:IsSetCard(0x3b)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920272.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920272.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c98920272.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920272.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920272.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end