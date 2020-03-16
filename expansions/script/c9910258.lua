--幽鬼兔 木叶咲耶
function c9910258.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910258)
	e1:SetCondition(c9910258.condition)
	e1:SetCost(c9910258.cost)
	e1:SetTarget(c9910258.target)
	e1:SetOperation(c9910258.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910259)
	e2:SetCost(c9910258.rmcost)
	e2:SetTarget(c9910258.rmtg)
	e2:SetOperation(c9910258.rmop)
	c:RegisterEffect(e2)
end
function c9910258.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c9910258.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910258.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c9910258.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9910258.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsCanRemoveCounter(tp,1,0,0x953,4,REASON_COST) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RemoveCounter(tp,1,0,0x953,4,REASON_COST)
end
function c9910258.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9910258.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910258.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9910258.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910258.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
