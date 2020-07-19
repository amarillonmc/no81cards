--明月栞那
function c9910607.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910607)
	e1:SetCost(c9910607.cost)
	e1:SetTarget(c9910607.target)
	e1:SetOperation(c9910607.operation)
	c:RegisterEffect(e1)
end
function c9910607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910607.effilter(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
end
function c9910607.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local id=Duel.GetTurnCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910607.effilter,tp,0,LOCATION_GRAVE,1,nil,id) end
end
function c9910607.operation(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c9910607.effilter,tp,0,LOCATION_GRAVE,nil,id)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(9910607,0))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCondition(c9910607.discon)
		e1:SetCost(c9910607.discost)
		e1:SetOperation(c9910607.disop)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9910607.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField()
end
function c9910607.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetFlagEffect(tp,9910607)==0 end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,9910607,RESET_CHAIN,0,1)
end
function c9910607.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910607,1))
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end

