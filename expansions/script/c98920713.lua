--急袭猛禽-聚合猎鹰
function c98920713.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920713,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920713)
	e1:SetCost(c98920713.thcost)
	e1:SetCondition(c98920713.thcon)
	e1:SetTarget(c98920713.thtg)
	e1:SetOperation(c98920713.thop)
	c:RegisterEffect(e1)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(98920713,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98920713.cost)
	e1:SetTarget(c98920713.atktg)
	e1:SetOperation(c98920713.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c98920713.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920713.distg)
	e2:SetOperation(c98920713.disop)
	c:RegisterEffect(e2)
end
function c98920713.costfilter(c,tp)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c98920713.srfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c98920713.srfilter(c,code)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and not c:IsCode(code) and c:IsAbleToHand()
end
function c98920713.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920713.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920713.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c98920713.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.ConfirmCards(1-tp,tc)
end
function c98920713.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920713.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920713.srfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920713.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c98920713.atkfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER)
end
function c98920713.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local ag=Duel.GetMatchingGroup(c98920713.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local ms=ag:GetClassCount(Card.GetCode)*-100
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ms)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c98920713.disfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRankAbove(10) and c:IsFaceup()
end
function c98920713.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920713.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c98920713.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98920713.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end