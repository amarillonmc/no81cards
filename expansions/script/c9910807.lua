--天体震荡
function c9910807.initial_effect(c)
	aux.AddRitualProcGreater2(c,c9910807.filter,LOCATION_HAND+LOCATION_GRAVE,c9910807.filter)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910807)
	e2:SetCost(c9910807.setcost)
	e2:SetTarget(c9910807.settg)
	e2:SetOperation(c9910807.setop)
	c:RegisterEffect(e2)
end
function c9910807.filter(c)
	return c:IsSetCard(0x6951)
end
function c9910807.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910807.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c9910807.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then Duel.SSet(tp,c) end
end
