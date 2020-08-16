--不知火流 闪刀炎阵
function c978210005.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(978210005,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c978210005.condition)
	e1:SetTarget(c978210005.target)
	e1:SetOperation(c978210005.activate)
	c:RegisterEffect(e1)
----
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c978210005.thtg)
	e2:SetOperation(c978210005.thop)
	c:RegisterEffect(e2)
----
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function c978210005.cfilter(c)
	return c:GetSequence()<5
end
function c978210005.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c978210005.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c978210005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c978210005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
------
function c978210005.thfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c978210005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210005.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c978210005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210005.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end