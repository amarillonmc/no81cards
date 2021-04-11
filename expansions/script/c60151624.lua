--源聚的愿望
function c60151624.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_RECOVER)
	e2:SetOperation(c60151624.ctop)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60151624,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,60151624)
	e4:SetCost(c60151624.spcost)
	e4:SetTarget(c60151624.sptg)
	e4:SetOperation(c60151624.spop)
	c:RegisterEffect(e4)
end
function c60151624.ctop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		e:GetHandler():AddCounter(0x1b,1)
	end
end
function c60151624.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1b,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1b,3,REASON_COST)
end
function c60151624.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsRace(RACE_FAIRY) or c:IsRace(RACE_SPELLCASTER)) 
		and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151624.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60151624.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
end
function c60151624.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151624.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end