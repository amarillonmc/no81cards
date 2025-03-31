--叱影军一闪
function c130001237.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(130001237,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c130001237.cost)
	e2:SetTarget(c130001237.target)
	e2:SetOperation(c130001237.activate)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(130001237,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c130001237.cost)
	e3:SetTarget(c130001237.target1)
	e3:SetOperation(c130001237.activate1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(130001237,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,130001237)
	e4:SetCost(c130001237.thcost)
	e4:SetTarget(c130001237.thtg)
	e4:SetOperation(c130001237.thop)
	c:RegisterEffect(e4)
end
function c130001237.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x852)
end
function c130001237.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130001237.cfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c130001237.cfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c130001237.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c130001237.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c130001237.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c130001237.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c130001237.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c130001237.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c130001237.activate1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c130001237.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c130001237.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c130001237.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x852)
end
function c130001237.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130001237.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c130001237.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c130001237.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end