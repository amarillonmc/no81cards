--混合咖啡·Sister
function c9910576.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910576,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910576)
	e1:SetCost(c9910576.cost)
	e1:SetTarget(c9910576.target)
	e1:SetOperation(c9910576.operation)
	c:RegisterEffect(e1)
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910577)
	e2:SetCost(c9910576.gecost)
	e2:SetTarget(c9910576.getg)
	e2:SetOperation(c9910576.geop)
	c:RegisterEffect(e2)
end
function c9910576.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910576.tgfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToGrave()
end
function c9910576.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c9910576.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910576.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND 
	local chain=Duel.GetCurrentChain()
	if chain>1 then
		local te=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()==e:GetHandler() then loc=LOCATION_HAND+LOCATION_DECK end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910576.tgfilter,tp,loc,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9910576.gecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
end
function c9910576.getg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
end
function c9910576.geop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,2,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9910576,2))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetTarget(c9910576.tgtg)
		e1:SetOperation(c9910576.tgop)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9910576.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c9910576.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
