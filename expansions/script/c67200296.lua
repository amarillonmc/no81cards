--潜藏于封缄之都的死斗
function c67200296.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c67200296.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c67200296.activate)
	c:RegisterEffect(e1)

end
function c67200296.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and loc==LOCATION_EXTRA and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c67200296.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	end
end
function c67200296.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x674) and  Duel.SelectYesNo(tp,aux.Stringid(67200296,1)) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
