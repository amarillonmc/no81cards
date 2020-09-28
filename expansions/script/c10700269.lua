--双龙的天穹
function c10700269.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700269,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10700269.condition1)
	e1:SetCost(c10700269.target1)
	e1:SetOperation(c10700269.activate1)
	c:RegisterEffect(e1)	
end
function c10700269.tgfilter(c,e,tp)
	if not c:IsFaceup() or not c:IsRace(RACE_DRAGON) then return false end
	local g=Duel.GetMatchingGroup(c10700269.spfilter2,tp,LOCATION_DECK,0,nil,e,tp,c)
	return g:GetClassCount(Card.GetCode)>0
end
function c10700269.spfilter(c,e,tp,tc)
	return c:GetOriginalAttribute()~=tc:GetOriginalAttribute() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700269.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10700269.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10700269.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10700269.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14604710.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c14604710.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc)
	if ft>0 and g:GetClassCount(Card.GetCode)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)

end