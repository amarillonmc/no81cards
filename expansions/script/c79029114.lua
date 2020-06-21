--汐斯塔·部署-花园中的约定
function c79029114.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,79029113)   
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c79029114.tdtg)
	e1:SetOperation(c79029114.tdop)
	c:RegisterEffect(e1)
end
function c79029114.spfilter1(c,e,tp)
	if c:IsFaceup() and c:IsCode(79029030) then
		local zone=c:GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c79029114.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,zone)
	else return false end
end
function c79029114.spfilter2(c,e,tp,zone)
	return c:IsCode(79029113) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,zone)
end
function c79029114.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029114.spfilter1(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c79029114.spfilter1,tp,LOCATION_MZONE,0,1,c,e,tp) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029114.spfilter1,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK)
end 
function c79029114.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetFirstTarget()
	if lc:IsRelateToEffect(e) and lc:IsFaceup() then
		local zone=lc:GetLinkedZone(tp)
		if zone==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c79029114.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,zone):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP,zone) 
end
end












