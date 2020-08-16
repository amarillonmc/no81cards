--告死天使
function c9951619.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9951619.target)
	e1:SetOperation(c9951619.activate)
	c:RegisterEffect(e1)
end
function c9951619.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,1-tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c9951619.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_MZONE,0,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end

