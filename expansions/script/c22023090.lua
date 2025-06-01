--人理之基 乔治·梅里爱
function c22023090.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023090)
	e1:SetCondition(c22023090.spcon1)
	e1:SetTarget(c22023090.sptg1)
	e1:SetOperation(c22023090.spop1)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023090,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023091)
	e2:SetCost(c22023090.rmcost)
	e2:SetTarget(c22023090.rmtg)
	e2:SetOperation(c22023090.rmop)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023090,4))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22023091)
	e3:SetCondition(c22023090.erescon)
	e3:SetCost(c22023090.cost1)
	e3:SetTarget(c22023090.rmtg)
	e3:SetOperation(c22023090.rmop)
	c:RegisterEffect(e3)
end
c22023090.effect_with_darkguda=true
function c22023090.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023090.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023090.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023090.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023090.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023090.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023090.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_GRAVE)
end
function c22023090.thfilter(c)
	return c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023090.thfilter2(c)
	return c:IsSetCard(0xff1) and c:IsAbleToHand()
end
function c22023090.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023090,2))
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023090,3))
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c22023090.thfilter2,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c22023090.thfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c22023090.thfilter2,tp,LOCATION_GRAVE,0,2,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c22023090.thfilter2,tp,LOCATION_GRAVE,0,1,2,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c22023090.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c22023090.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023090.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end