--混合咖啡·Sweet
function c9910573.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910573,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910573)
	e1:SetCost(c9910573.cost)
	e1:SetTarget(c9910573.target)
	e1:SetOperation(c9910573.operation)
	c:RegisterEffect(e1)
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910574)
	e2:SetCost(c9910573.gecost)
	e2:SetTarget(c9910573.getg)
	e2:SetOperation(c9910573.geop)
	c:RegisterEffect(e2)
end
function c9910573.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910573.thfilter(c)
	return c:IsSetCard(0xc951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910573.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c9910573.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910573.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910573.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910573.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local chain=Duel.GetCurrentChain()
		if chain==1 then return end
		local te=Duel.GetChainInfo(chain-1,CHAININFO_TRIGGERING_EFFECT)
		local mg=Duel.GetMatchingGroup(c9910573.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if te and te:GetHandler()==e:GetHandler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910573,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9910573.gecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
end
function c9910573.getg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
end
function c9910573.geop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,2,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9910573,2))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetTarget(c9910573.tdtg)
		e1:SetOperation(c9910573.tdop)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9910573.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c9910573.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910573.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9910573.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9910573.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910573.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
