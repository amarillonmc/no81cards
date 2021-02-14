--后巴别塔·临光
function c79035105.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79035105)
	e1:SetTarget(c79035105.sptg1)
	e1:SetOperation(c79035105.spop1)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,214017)
	e2:SetCondition(c79035105.spcon)
	e2:SetTarget(c79035105.sptg)
	e2:SetOperation(c79035105.spop)
	c:RegisterEffect(e2)   

end
function c79035105.cfilter2(c,tp)
	return c:IsSetCard(0xca3) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c79035105.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(c79035105.cfilter2,1,nil,tp)
end
function c79035105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
end
function c79035105.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
	Duel.BreakEffect()
	Duel.Recover(tp,100,REASON_EFFECT)
	end
end
function c79035105.spfil(c,e,tp)
	return c:IsSetCard(0xca3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79035105.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035105.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79035105.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79035105.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
	--
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e2:SetTarget(c79035105.actfilter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
end
function c79035105.actfilter(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and not c:IsSetCard(0xca3)
end









