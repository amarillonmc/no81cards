--指挥官超量型
function c25800093.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,25800080,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800093,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,25800093)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c25800093.condition)
	e1:SetCost(c25800093.cost)
	e1:SetTarget(c25800093.target)
	e1:SetOperation(c25800093.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(25800093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,25800094)
	e2:SetCost(c25800093.cost)
	e2:SetTarget(c25800093.thtg)
	e2:SetOperation(c25800093.thop)
	c:RegisterEffect(e2)
	
end
------1

function c25800093.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,25800010)
end
function c25800093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c25800093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c25800093.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-----2
function c25800093.filter(c)
	return c:IsSetCard(0x211)  and c:IsAbleToHand()
end
function c25800093.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25800093.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25800093.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c25800093.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

