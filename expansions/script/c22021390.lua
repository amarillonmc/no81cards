--人理之诗 吾枪通达万物
function c22021390.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c22021390.cost)
	e1:SetCondition(c22021390.spcon)
	e1:SetTarget(c22021390.target)
	e1:SetOperation(c22021390.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetCondition(c22021390.condition)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c22021390.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22021390.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c22021390.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021390.cfilter,1,nil,1-tp)
end
function c22021390.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021390,0))
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22021390.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22021390.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021390.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22021390.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c22021390.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22021390.desfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.SelectOption(tp,aux.Stringid(22021390,1))
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
