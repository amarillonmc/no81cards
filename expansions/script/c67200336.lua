--结天缘 米可尤
function c67200336.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c67200336.descon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200336,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c67200336.sptg)
	e2:SetOperation(c67200336.spop)
	c:RegisterEffect(e2)
end
function c67200336.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),67200337)
end
--
function c67200336.thfilter(c)
	return c:IsSetCard(0x671) and c:IsAbleToHand()
end
function c67200336.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c67200336.thfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function c67200336.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,c67200336.thfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

