--D.A.L 诱发型空间震
function c33401306.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33401306.condition)
	e1:SetTarget(c33401306.target)
	e1:SetOperation(c33401306.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)  
	e2:SetCondition(c33401306.condition2)
	e2:SetCost(c33401306.cost) 
	e2:SetTarget(c33401306.target2)
	e2:SetOperation(c33401306.activate2)
	c:RegisterEffect(e2)
end
function c33401306.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER)
end
function c33401306.condition(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.IsExistingMatchingCard(c33401306.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33401306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_FZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_FZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c33401306.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_FZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

function c33401306.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33401306.cfilter,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(33401306)
end
function c33401306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c33401306.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33401306.activate2(e,tp,eg,ep,ev,re,r,rp)
   if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end  
end

