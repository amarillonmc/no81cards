--冥界的圣灵骑士 兰斯洛特
function c54363188.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,c54363188.lkcheck,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(c54363188.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c54363188.descon)
	e3:SetTarget(c54363188.destg)
	e3:SetOperation(c54363188.desop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(54363188,2))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,54363188)
	e4:SetCondition(c54363188.discon)
	e4:SetCost(c54363188.discost)
	e4:SetTarget(c54363188.distg)
	e4:SetOperation(c54363188.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(54363188,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,54363188)
	e5:SetCondition(c54363188.discon)
	e5:SetCost(c54363188.discost)
	e5:SetTarget(c54363188.thtg)
	e5:SetOperation(c54363188.thop)
	c:RegisterEffect(e5)
end
function c54363188.lkcheck(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807)
end
function c54363188.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(c54363188.lkfilter,1,nil)
end
function c54363188.lkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c54363188.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetLinkedGroup():IsExists(c54363188.lkfilter,1,nil) 
end
function c54363188.filter(c)
	return c:IsFaceup()
end
function c54363188.filter1(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToDeckOrExtraAsCost()
end
function c54363188.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c54363188.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c54363188.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c54363188.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c54363188.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c54363188.discon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler()
end
function c54363188.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363188.filter1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363188.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363188.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c54363188.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function c54363188.thfilter(c)
	return (c:IsSetCard(0x107a) or c:IsSetCard(0x207a) or c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813)) and c:IsAbleToHand()
end
function c54363188.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363188.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c54363188.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c54363188.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end