--天体震荡
function c9910807.initial_effect(c)
	aux.AddRitualProcGreater2(c,aux.TRUE,LOCATION_HAND,c9910807.filter)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910807)
	e2:SetTarget(c9910807.settg)
	e2:SetOperation(c9910807.setop)
	c:RegisterEffect(e2)
end
function c9910807.filter(c)
	return c:IsSetCard(0x6951)
end
function c9910807.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c9910807.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then Duel.SSet(tp,c) end
end
