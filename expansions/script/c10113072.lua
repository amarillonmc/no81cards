--次元反击
function c10113072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c10113072.cost)
	e1:SetCondition(c10113072.condition)
	e1:SetTarget(c10113072.target)
	e1:SetOperation(c10113072.activate)
	c:RegisterEffect(e1)	
end
function c10113072.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c10113072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)
	Duel.Release(g,REASON_COST)
end
function c10113072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c10113072.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c10113072.bantg)
	e1:SetLabel(re:GetHandler():GetCode())
	Duel.RegisterEffect(e1,tp)
end
function c10113072.bantg(e,c)
	return c:IsCode(e:GetLabel())
end