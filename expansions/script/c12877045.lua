--狩猎游戏的曙光
function c12877045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12877045)
	e1:SetTarget(c12877045.target)
	e1:SetOperation(c12877045.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12877046)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c12877045.sptg)
	e2:SetOperation(c12877045.spop)
	c:RegisterEffect(e2)
end
function c12877045.pfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x9a7b) and c:IsFaceupEx() and not c:IsForbidden()
end
function c12877045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c12877045.pfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c12877045.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c12877045.pfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
end
function c12877045.spfilter(c,e,tp)
	return c:IsOriginalSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_SELF,tp,true,false)
end
function c12877045.rlfilter(c)
	return c:IsFaceup() and c:IsReleasableByEffect()
end
function c12877045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c12877045.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and
		Duel.IsExistingMatchingCard(c12877045.rlfilter,tp,LOCATION_ONFIELD,0,1,nil) and
		Duel.IsExistingMatchingCard(c12877045.rlfilter,tp,0,LOCATION_ONFIELD,1,nil) and
		Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,0,0)
end
function c12877045.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c12877045.rlfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c12877045.rlfilter,tp,LOCATION_ONFIELD,0,1,nil)) then return end
	local rg=Duel.SelectMatchingCard(tp,c12877045.rlfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local rg2=Duel.SelectMatchingCard(tp,c12877045.rlfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	rg:Merge(rg2)
	Duel.Release(rg,REASON_EFFECT)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c12877045.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	end
end
