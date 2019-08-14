--幻灭的虚实
function c60150507.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetCountLimit(1,60150507+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c60150507.cost)
	e1:SetTarget(c60150507.destg)
	e1:SetOperation(c60150507.desop)
	c:RegisterEffect(e1)
end
function c60150507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60150507.filter(c)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsAbleToRemove() and c:IsDestructable()
end
function c60150507.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c60150507.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150507.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.IsExistingMatchingCard(c60150507.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c60150507.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60150507.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local lv=og:GetSum(Card.GetLevel)
	local rk=og:GetSum(Card.GetRank)
	Duel.Damage(1-tp,lv*100,REASON_EFFECT)
	Duel.Damage(1-tp,rk*100,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc and (tc:IsFaceup() or tc:IsFacedown()) and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP+POS_FACEDOWN,REASON_EFFECT)
	end
end