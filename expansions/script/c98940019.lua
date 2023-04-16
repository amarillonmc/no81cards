--十二兽 鼠威
function c98940019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),5,2,c98940019.ovfilter,aux.Stringid(98940019,0),99,c98940019.xyzop)
	c:EnableReviveLimit()
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98940019.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c98940019.defval)
	c:RegisterEffect(e2)
--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98940019,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c98940019.condition)
	e4:SetCost(c98940019.cost)
	e4:SetTarget(c98940019.target)
	e4:SetOperation(c98940019.operation)
	c:RegisterEffect(e4)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940019,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c98940019.cost)
	e1:SetCondition(c98940019.thcon)
	e1:SetTarget(c98940019.thtg)
	e1:SetOperation(c98940019.thop)
	c:RegisterEffect(e1)
end
function c98940019.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(98940019)
end
function c98940019.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98940019)==0 end
	Duel.RegisterFlagEffect(tp,98940019,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98940019.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c98940019.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98940019.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c98940019.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c98940019.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98940019.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c98940019.condition(e,tp,eg,ep,ev,re,r,rp)
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	return ep~=tp and Duel.IsChainNegatable(ev)
end
function c98940019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98940019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98940019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98940019.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c98940019.thfilter(c)
	return c:IsSetCard(0xf1) and c:IsAbleToHand()
end
function c98940019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940019.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98940019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98940019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end