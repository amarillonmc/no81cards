--折纸使的相惜
function c9910040.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910040+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910040.target)
	e1:SetOperation(c9910040.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c9910040.descost)
	e2:SetTarget(c9910040.destg)
	e2:SetOperation(c9910040.desop)
	c:RegisterEffect(e2)
end
function c9910040.stfilter(c)
	return c:IsSetCard(0x3950) and c:IsLevel(5) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c9910040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910040.stfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c9910040.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and aux.dncheck(g)
end
function c9910040.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910040.stfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
	local pt=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pt=pt+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pt=pt+1 end
	if #g==0 or pt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g:SelectSubGroup(tp,c9910040.fselect,false,1,pt)
	for tc in aux.Next(sg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c9910040.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c9910040.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910040.cfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910040.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9910040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910040.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x3950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910040.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	local p=tc:GetControler()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910040.spfilter),p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,p)
	if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and #tg>0 and Duel.SelectYesNo(p,aux.Stringid(9910040,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=tg:Select(p,1,1,nil)
		Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
	end
end
