--余晖的远古造物
function c9910744.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9910744+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910744.condition)
	e1:SetCost(c9910744.cost)
	e1:SetTarget(c9910744.target)
	e1:SetOperation(c9910744.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910744,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9910744.cfilter0(c)
	return c:IsFaceup() and c:IsSetCard(0xc950)
end
function c9910744.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910744.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c9910744.cfilter0,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910744.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not c:IsLocation(LOCATION_HAND)
		or Duel.IsExistingMatchingCard(c9910744.cfilter,tp,LOCATION_ONFIELD,0,1,c)) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910744.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c9910744.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=0 then
		e:SetCategory(e:GetCategory()|CATEGORY_TODECK)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_TODECK)
	end
end
function c9910744.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc950) and c:IsAbleToDeck()
end
function c9910744.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) or e:GetLabel()==0 then return end
	local g1=Duel.GetMatchingGroup(c9910744.tdfilter,tp,LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if #g1>=3 and #g2+#g3>0 and Duel.SelectYesNo(tp,aux.Stringid(9910744,0)) then
		Duel.BreakEffect()
		local sg=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,3,3,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
		if #g2>0 and (#g3==0 or Duel.SelectOption(tp,aux.Stringid(9910744,1),aux.Stringid(9910744,2))==0) then
			local sg2=g2:RandomSelect(tp,1)
			sg:Merge(sg2)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg3=g3:Select(tp,1,1,nil)
			Duel.HintSelection(sg3)
			sg:Merge(sg3)
		end
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
