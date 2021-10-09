--毒酒和面具
function c9950839.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950839,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950839+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950839.target)
	e1:SetOperation(c9950839.activate)
	c:RegisterEffect(e1)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950839,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9950839+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9950839.condition)
	e1:SetTarget(c9950839.target2)
	e1:SetOperation(c9950839.activate2)
	c:RegisterEffect(e1)
end
function c9950839.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9950839.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950839.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950839.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950839.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9950839.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0xba5)
end
function c9950839.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950839.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9950839.filter2(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function c9950839.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9950839.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950839.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9950839.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetBaseAttack())
end
function c9950839.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetBaseAttack()>0 then
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
