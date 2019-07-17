--梦日记
function c71400031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400031.tg)
	e1:SetOperation(c71400031.op)
	e1:SetCountLimit(1,71400031+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400031.filter(c)
	return c:IsSetCard(0x714) and c:GetReason() & REASON_DESTROY~=0 and not c:IsCode(71400031) and c:IsAbleToHand()
end
function c71400031.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400031.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c71400031.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c71400031.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400031.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*500)
end