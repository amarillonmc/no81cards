--URBEX CRISIS-袭击
function c65010521.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65010521)
	e1:SetCondition(c65010521.condition)
	e1:SetTarget(c65010521.target)
	e1:SetOperation(c65010521.activate)
	c:RegisterEffect(e1)
end
c65010521.setname="URBEX"
function c65010521.cfilter(c)
	return c:IsFaceup() and c.setname=="URBEX"
end
function c65010521.sfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65010521.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65010521.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>=7 and Duel.GetMatchingGroupCount(c65010521.sfil,tp,LOCATION_REMOVED,0,nil)>=3
end
function c65010521.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c65010521.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c65010521.sfil,tp,LOCATION_REMOVED,0,3,3,nil)
			if g:GetCount()==3 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end
end