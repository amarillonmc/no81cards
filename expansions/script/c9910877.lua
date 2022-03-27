--舞丝的阿瑞妮达
function c9910877.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910877)
	e1:SetCondition(c9910877.spcon)
	e1:SetTarget(c9910877.sptg)
	e1:SetOperation(c9910877.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910878)
	e2:SetCondition(c9910877.rmcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910877.rmtg)
	e2:SetOperation(c9910877.rmop)
	c:RegisterEffect(e2)
end
function c9910877.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910877.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910877.thfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and aux.IsCodeListed(c,9910871)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910877.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910877.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,SUMMON_TYPE_NORMAL) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910877,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910877.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c9910877.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910877.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910877.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9910877.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
