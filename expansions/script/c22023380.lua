--人理之基 荆轲
function c22023380.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023380,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023380)
	e1:SetCondition(c22023380.descon)
	e1:SetCost(c22023380.cost)
	e1:SetTarget(c22023380.target)
	e1:SetOperation(c22023380.operation)
	c:RegisterEffect(e1)
end

function c22023380.descfilter(c)
	return  c:IsSetCard(0xff1)
end
function c22023380.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023380.descfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c22023380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22023380.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
function c22023380.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023380,1))
	local ag=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0xff1)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22023380.discon)
		e1:SetOperation(c22023380.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22023380.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(22023380)==0 and ep~=tp
end
function c22023380.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22023380,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,22023380)
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end