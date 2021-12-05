--煌闪骑士团·拉斯提
function c72412540.initial_effect(c)
		--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412540,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412540)
	e1:SetCost(c72412540.cost)
	e1:SetTarget(c72412540.target)
	e1:SetOperation(c72412540.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412540,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,72412541)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c72412540.thtg)
	e2:SetOperation(c72412540.thop)
	c:RegisterEffect(e2)
end
function c72412540.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c72412540.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c72412540.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c72412540.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72412540.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c72412540.filter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function c72412540.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c72412540.cfilter(c)
	return c:IsSetCard(0x6727) and c:IsFaceup()
end
function c72412540.thfilter(c)
	return c:IsSetCard(0xe727) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c72412540.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c72412540.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72412540.thfilter,tp,LOCATION_GRAVE,0,1,c) end
	local n=1
	if Duel.IsExistingMatchingCard(c72412490.cfilter,tp,LOCATION_MZONE,0,2,nil) then 
	n=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c72412540.thfilter,tp,LOCATION_GRAVE,0,1,n,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,nil,0,0)
end
function c72412540.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end