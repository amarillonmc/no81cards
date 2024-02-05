--奥山修正者 风行
function c67200908.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200908,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200907)
	e1:SetCost(c67200908.cost)
	e1:SetTarget(c67200908.sptg)
	e1:SetOperation(c67200908.spop)
	c:RegisterEffect(e1)
	--spsummon success
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(67200908,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCountLimit(1,67200908)
	e7:SetTarget(c67200908.sptg1)
	e7:SetOperation(c67200908.spop1)
	c:RegisterEffect(e7)  
	local e3=e7:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end
function c67200908.cfilter(c,tc,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp,Group.FromCards(c,tc))>0 
end
function c67200908.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200908.cfilter,tp,LOCATION_ONFIELD,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200908,3))
	local g=Duel.SelectMatchingCard(tp,c67200908.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,c,tp)+c
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200908.sfilter(c,e,tp)
	return c:IsSetCard(0x367a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(67200908)
end
function c67200908.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:IsCostChecked() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(c67200908.sfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c67200908.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200908.sfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--
--
function c67200908.spfilter(c,e,tp)
	return c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200908) and c:IsFaceup()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) 
end
function c67200908.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200908.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67200908.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200908.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end
