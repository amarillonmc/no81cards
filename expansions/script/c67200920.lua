--众星修正者 沐风
function c67200920.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200920,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCountLimit(1,67200921)
	e1:SetCondition(c67200920.spcon)
	e1:SetTarget(c67200920.sptg)
	e1:SetOperation(c67200920.spop)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200920,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,67200920)
	e2:SetTarget(c67200920.tetg)
	e2:SetOperation(c67200920.teop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
end
--
function c67200920.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c67200920.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c67200920.cfilter,1,c,tp) and not eg:IsContains(c)
end
function c67200920.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200920.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200920.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa67a) and not c:IsCode(67200920)
end
function c67200920.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200920.tefilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c67200920.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200920,3))
	local g=Duel.SelectMatchingCard(tp,c67200920.tefilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end

