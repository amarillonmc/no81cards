--人理之诗 不带剑的誓言
function c22021200.initial_effect(c)
	aux.AddCodeList(c,22023340,22021190)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22021200)
	e1:SetCondition(c22021200.cecondition)
	e1:SetOperation(c22021200.ceoperation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021200,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22021200.handcon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021200,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22021201)
	e3:SetCost(c22021200.thcost)
	e3:SetTarget(c22021200.thtg)
	e3:SetOperation(c22021200.thop)
	c:RegisterEffect(e3)
end
function c22021200.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(tp,22023340)>0
end
function c22021200.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22021200.repop)
end
function c22021200.repop(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(1-tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(1-tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(1-tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
end
function c22021200.handcon(e)
	return Duel.GetFlagEffect(tp,22023340)>2
end
function c22021200.cfilter(c)
	return c:IsSetCard(22021190) and c:IsAbleToRemoveAsCost()
end
function c22021200.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c22021200.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22021200.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22021200.thfilter(c)
	return c:IsCode(22023340) and c:IsAbleToHand()
end
function c22021200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021200.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22021200.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22021200.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
