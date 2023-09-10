--全土灭杀转生波
function c98920519.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98920519.condition)
	e1:SetTarget(c98920519.target)
	e1:SetOperation(c98920519.activate)
	c:RegisterEffect(e1)
end
function c98920519.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==43378048 
end
function c98920519.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920519.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920519.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c98920519.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98920519.aclimit(e,re,tp)
	return not (re:GetHandler():IsCode(6007213) or re:GetHandler():IsCode(32491822) or re:GetHandler():IsCode(69890967))
end
function c98920519.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end