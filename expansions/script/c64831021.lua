--终末旅者 罗伊斯
function c64831021.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c64831021.cost)
	e1:SetTarget(c64831021.target)
	e1:SetOperation(c64831021.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,64831021)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c64831021.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c64831021.tdtg)
	e2:SetOperation(c64831021.tdop)
	c:RegisterEffect(e2)
end
function c64831021.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5410) and not c:IsCode(64831021)
end
function c64831021.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c64831021.cfilter,1,nil)
end
function c64831021.filterfilter(c)
	return c:IsSetCard(0x5410)
end
function c64831021.spfilter(c,eg,e,tp)
	local mg=eg:Filter(c64831021.filterfilter,nil)
	local tc=mg:GetFirst()
	local check=0
	while tc do
		if c:GetCode()==tc:GetCode() then check=1 end
		tc=mg:GetNext()
	end
	return c:IsSetCard(0x5410) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and check==0 
end
function c64831021.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64831021.spfilter,tp,LOCATION_DECK,0,1,nil,eg,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c64831021.tdop(e,tp,eg,ep,ev,re,r,rp)
	local mg=eg:Filter(c64831021.filterfilter,nil)
	if Duel.SendtoDeck(mg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c64831021.spfilter,tp,LOCATION_DECK,0,1,nil,eg,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c64831021.spfilter,tp,LOCATION_DECK,0,1,1,nil,eg,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c64831021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c64831021.spfilter1(c,e,tp)
	return c:IsAttack(500) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and not c:IsCode(64831021) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64831021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64831021.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c64831021.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64831021.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end