--青色眼睛的光临
function c98920071.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920071,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98920071)
	e1:SetCondition(c98920071.condition)
	e1:SetTarget(c98920071.target)
	e1:SetOperation(c98920071.activate)
	c:RegisterEffect(e1)
--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c98920071.handcon)
	c:RegisterEffect(e2)
end	
function c98920071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd)
end
function c98920071.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98920071.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c98920071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920071.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c98920071.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) then
		  local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		  local tc=g:GetFirst()
		  while tc do
			  Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_DISABLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetCode(EFFECT_DISABLE_EFFECT)
			  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			  e2:SetValue(RESET_TURN_SET)
			  tc:RegisterEffect(e2)
			  tc=g:GetNext()
		   end
	   end
	end
end
function c98920071.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xdd) and c:IsType(TYPE_FUSION)
end
function c98920071.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd) and not c:IsType(TYPE_EFFECT)
end
function c98920071.handcon(e)
	return Duel.IsExistingMatchingCard(c98920071.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
