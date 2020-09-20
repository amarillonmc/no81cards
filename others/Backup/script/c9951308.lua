--伊莉雅·誓约胜利之剑
function c9951308.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951308,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9951308.cecondition)
	e1:SetTarget(c9951308.cetarget)
	e1:SetOperation(c9951308.ceoperation)
	c:RegisterEffect(e1)
  --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951308,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9951308.thtg)
	e3:SetOperation(c9951308.thop)
	c:RegisterEffect(e3)
end
function c9951308.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c9951308.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,nil,REASON_EFFECT)
	end
end
function c9951308.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaba8)
end
function c9951308.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c9951308.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9951308.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9951308.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951308.thfilter,rp,LOCATION_MZONE,0,1,nil) end
end
function c9951308.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9951308.repop)
end
function c9951308.thfilter(c)
	return c:IsSetCard(0xaba8) and not c:IsCode(9951308) and c:IsAbleToHand()
end
function c9951308.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951308.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951308.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951308.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
