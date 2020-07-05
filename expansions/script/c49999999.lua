--超重力
function c49999999.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c49999999.target)
	e1:SetOperation(c49999999.activate)
	c:RegisterEffect(e1)
end
function c49999999.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	 Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c49999999.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.SendtoDeck(g2,tp,nil,REASON_EFFECT)
	Duel.SendtoDeck(g1,1-tp,nil,REASON_EFFECT)
end
