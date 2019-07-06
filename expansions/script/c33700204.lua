--Heavenly Maid : Exotic Purge
function c33700204.initial_effect(c)
	--Send 1 "Heavenly Maid" monster you control to the GY. If you do, send 1 card your opponent control to the GY. You can only activate 1 "Heavenly Maid : Exotic Purge" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700204)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetTarget(c33700204.tg)
	e1:SetOperation(c33700204.op)
	c:RegisterEffect(e1)
end
function c33700204.filter(c)
	return c:IsSetCard(0x444) and c:IsAbleToGrave()
end
function c33700204.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700204.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	local g1=Duel.GetMatchingGroup(c33700204.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
end
function c33700204.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33700204.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(dg)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
