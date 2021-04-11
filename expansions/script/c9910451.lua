--韶光少女 僧间理亚
function c9910451.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c9910451.spcon)
	e1:SetCost(c9910451.spcost)
	e1:SetTarget(c9910451.sptg)
	e1:SetOperation(c9910451.spop)
	c:RegisterEffect(e1)
end
function c9910451.cfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9910451.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910451.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910451.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,3,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c9910451.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910451.spfilter(c,e,tp)
	return c:IsSetCard(0x9950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910451.thfilter(c,tp)
	return c:IsSetCard(0x9950) and c:IsAbleToHand()
end
function c9910451.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 or e:GetLabel()<2 then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910451.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c9910451.thfilter,tp,LOCATION_DECK,0,nil)
	if e:GetLabel()>=2 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910451,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==3 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910451,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
end
