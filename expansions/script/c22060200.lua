--异天枝-尚达丰
function c22060200.initial_effect(c)
	--REMOVE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060200,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060200)
	e1:SetCost(c22060200.cost)
	e1:SetCondition(c22060200.rmcon)
	e1:SetTarget(c22060200.rmtg)
	e1:SetOperation(c22060200.rmop)
	c:RegisterEffect(e1)
end
function c22060200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22060200.filter1(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c22060200.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22060200.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,10,nil)
end
function c22060200.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22060200.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end