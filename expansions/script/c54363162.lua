--于冥界的创伤
function c54363162.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54363162,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,54363162+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c54363162.discost)
	e1:SetCondition(c54363162.condition)
	e1:SetTarget(c54363162.target)
	e1:SetOperation(c54363162.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54363162,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,54363162+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c54363162.discost)
	e2:SetCondition(c54363162.condition)
	e2:SetTarget(c54363162.target1)
	e2:SetOperation(c54363162.activate1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(54363162,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c54363162.cost)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c54363162.settg)
	e3:SetOperation(c54363162.setop)
	c:RegisterEffect(e3)
end
function c54363162.filter(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToDeckOrExtraAsCost()
end
function c54363162.filter1(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToDeckOrExtraAsCost()  and not c:IsCode(54363162)
end
function c54363162.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))
end
function c54363162.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c54363162.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c54363162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363162.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363162.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363162.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363162.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363162.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363162.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	end
end
function c54363162.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		if Duel.Destroy(ec,REASON_EFFECT) then
			local g=Duel.GetDecktopGroup(tp,3)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end
function c54363162.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==3 and re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
	end
end
function c54363162.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		if Duel.Remove(ec,POS_FACEDOWN,REASON_EFFECT) then
			local g=Duel.GetDecktopGroup(tp,3)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c54363162.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c54363162.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end