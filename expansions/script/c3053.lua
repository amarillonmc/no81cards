--祭礼术士 阿莱贝尔
function c3053.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3053,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3053)
	e1:SetCost(c3053.sgcost)
	e1:SetTarget(c3053.sgtg)
	e1:SetOperation(c3053.sgop)
	c:RegisterEffect(e1)
	--deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3053,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,3053)
	e2:SetCost(c3053.cost)
	e2:SetTarget(c3053.target)
	e2:SetOperation(c3053.operation)
	c:RegisterEffect(e2)
end	
function c3053.cfilter(c)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c3053.sgfilter(c)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_MONSTER) and c:GetLevel()==6 and c:IsAbleToGrave()
end
function c3053.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3053.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3053.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3053.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler(tp) and chkc:GetLocation(LOCATION_DECK) end
	if chk==0 then return Duel.IsExistingTarget(c3053.sgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c3053.sgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c3053.sgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c3053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
end
function c3053.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,2) then return end
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	local sg=g:Filter(Card.IsSetCard,nil,0x1012)
	if sg:GetCount()>0 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.ConfirmCards(1-tp,g)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT)
	else	
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end	
end