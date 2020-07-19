--瞻星之人
function c9981463.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981463+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981463.cost)
	e1:SetTarget(c9981463.target)
	e1:SetOperation(c9981463.activate)
	c:RegisterEffect(e1)
end
function c9981463.costfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsLinkAbove(4)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c9981463.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,8000) and Duel.CheckReleaseGroup(tp,c9981463.costfilter,1,nil,tp) end
	Duel.PayLPCost(tp,8000)
	local sg=Duel.SelectReleaseGroup(tp,c9981463.costfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c9981463.rmfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c9981463.spfilter(c,e,tp)
	return ((c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0xba5) and c:IsAttackBelow(1000)  and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0) or (c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER))) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c9981463.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c9981463.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c9981463.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function c9981463.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local rmg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9981463.rmfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local rmct=rmg:GetClassCount(Card.GetCode)
	local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9981463.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local spct=spg:GetClassCount(Card.GetCode)
	local ct=math.min(7,ft,spct,rmct)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=rmg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	ct=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=spg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end

