--赛博空间的刑警
function c9911281.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911281)
	e1:SetCost(c9911281.cost)
	e1:SetTarget(c9911281.sptg1)
	e1:SetOperation(c9911281.spop1)
	c:RegisterEffect(e1)
	--spsummon self
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9911282)
	e2:SetTarget(c9911281.sptg2)
	e2:SetOperation(c9911281.spop2)
	c:RegisterEffect(e2)
end
function c9911281.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9911281.cfilter(c,e,tp)
	return c:IsSetCard(0x6950) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9911281.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function c9911281.spfilter(c,e,tp)
	return c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911281.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():IsPublic() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c9911281.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c9911281.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9911281.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9911281.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911281.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911281.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911281.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
