--L'Antica秘密基地
function c28372877.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	--e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c28372877.cost)
	--e0:SetOperation(c28372877.activate)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28372877,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c28372877.drcon)
	e1:SetTarget(c28372877.drtg)
	e1:SetOperation(c28372877.drop)
	c:RegisterEffect(e1)
end
function c28372877.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_DARK):FilterCount(Card.IsFaceup,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,ct) end
	Duel.DiscardDeck(tp,ct,REASON_COST)
end
function c28372877.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28372877.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,0x285):Filter(Card.IsFaceupEx,nil)
	local g2=Duel.GetMatchingGroup(c28372877.thfilter,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(28372877,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g1:Select(tp,1,#g1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,#dg,#dg,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c28372877.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()==3 and c:IsPreviousControler(tp)
end
function c28372877.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28372877.cfilter,1,nil,tp)
end
function c28372877.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c28372877.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	g:AddCard(e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
