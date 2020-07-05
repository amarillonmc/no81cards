--SWEEP·先锋干员-清道夫
function c79029145.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26889158,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029145)
	e1:SetCondition(c79029145.spcon)
	e1:SetTarget(c79029145.sptg)
	e1:SetOperation(c79029145.spop)
	c:RegisterEffect(e1)  
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52792430,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c79029145.spcon1)
	e3:SetTarget(c79029145.sptg1)
	e3:SetOperation(c79029145.spop1)
	c:RegisterEffect(e3)  
end
function c79029145.cfilter(c,tp)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and not c:IsCode(79029145) and c:IsControler(tp)
end
function c79029145.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029145.cfilter,1,nil,tp)
end
function c79029145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029145.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029145.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsLevelBelow(c:GetLevel()) and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function c79029145.spfilter(c,e,tp)
	return c:IsSetCard(0xa900) and not c:IsCode(79029145) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029145.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029145.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029145.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029145.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end