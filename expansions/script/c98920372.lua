--魔妖仙兽 八盐折神
function c98920372.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920372.mfilter,2,3,c98920372.lcheck)
	c:EnableReviveLimit()
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920372,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920372.thcon)
	e3:SetOperation(c98920372.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920372,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,98920372)
	e2:SetCondition(c98920372.negcon)
	e2:SetTarget(c98920372.negtg)
	e2:SetOperation(c98920372.negop)
	c:RegisterEffect(e2) 
--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920372,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,98930372)
	e2:SetTarget(c98920372.thtg1)
	e2:SetOperation(c98920372.thop1)
	c:RegisterEffect(e2)
end
function c98920372.mfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function c98920372.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xb3)
end
function c98920372.cfilter(c,ec)
	return c:IsFaceup() and (c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:IsSummonType(SUMMON_TYPE_NORMAL)) and ec:GetLinkedGroup():IsContains(c)
end
function c98920372.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920372.cfilter,1,nil,e:GetHandler())
end
function c98920372.thop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local g=eg:FilterCount(c98920372.cfilter,nil,e:GetHandler())
	 if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(g*400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c98920372.negcon(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and re:GetHandler():IsAttackBelow(atk-1)
end
function c98920372.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920372.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920372.thfilter(c)
	return c:IsSetCard(0xb3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920372.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920372.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAttackAbove(800) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920372.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920372.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end