--熔岩谷的晖望
function c49811464.initial_effect(c)
	--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c49811464.thcon)
	e1:SetTarget(c49811464.thtg)
	e1:SetOperation(c49811464.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,49811465)
	e2:SetCondition(c49811464.drcon)
	e2:SetTarget(c49811464.drtg)
	e2:SetOperation(c49811464.drop)
	c:RegisterEffect(e2)
end
function c49811464.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c49811464.thfilter(c)
	return c:IsCode(72142276,47658964,5439384) and c:IsAbleToHand()
end
function c49811464.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811464.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811464.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811464.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c49811464.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)-- and e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) or re:IsHasType(TYPE_SPELL+TYPE_TRAP))
end
function c49811464.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811464.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c49811464.damcon1)
	e1:SetOperation(c49811464.damop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811464.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0x39) and c:GetPreviousAttackOnField()>c:GetBaseAttack()
end
function c49811464.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811464.cfilter,1,nil,tp)
end
function c49811464.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811464)
	local g=eg:Filter(c49811464.cfilter,nil,tp)
	local val=0
	for tc in aux.Next(g) do
		val=val+tc:GetPreviousAttackOnField()-tc:GetBaseAttack()
	end
	Duel.Damage(1-tp,val,REASON_EFFECT)
end
