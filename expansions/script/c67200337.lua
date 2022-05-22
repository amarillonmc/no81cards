--结天缘 伊奥尔
function c67200337.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c67200337.descon)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200337,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c67200337.spcon)
	e3:SetTarget(c67200337.sptg)
	e3:SetOperation(c67200337.spop)
	c:RegisterEffect(e3)	
end
function c67200337.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),67200336)
end
--
function c67200337.spfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsSetCard(0x671)
end
function c67200337.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200337.spfilter,1,nil,tp)
end
function c67200337.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200337.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=eg:GetSum(Card.GetBaseAttack)
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end