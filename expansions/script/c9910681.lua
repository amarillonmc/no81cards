--神械的鏖战
function c9910681.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910681.condition)
	e1:SetTarget(c9910681.target)
	e1:SetOperation(c9910681.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910681)
	e2:SetCost(c9910681.thcost)
	e2:SetTarget(c9910681.thtg)
	e2:SetOperation(c9910681.thop)
	c:RegisterEffect(e2)
end
function c9910681.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910681.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc954)
end
function c9910681.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rec=Duel.GetMatchingGroupCount(c9910681.cfilter,tp,LOCATION_MZONE,0,nil)*2000
	if chk==0 then return rec>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c9910681.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local rec=Duel.GetMatchingGroupCount(c9910681.cfilter,tp,LOCATION_MZONE,0,nil)*2000
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function c9910681.filter(c)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER)
end
function c9910681.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	local label=0
	if g:IsExists(c9910681.filter,1,nil) then label=1 end
	e:SetLabel(label)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910681.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910681.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if e:GetLabel()~=1 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c9910681.distg)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c9910681.discon)
	e2:SetOperation(c9910681.disop)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c9910681.distg)
	e3:SetLabelObject(tc)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9910681.disfilter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function c9910681.distg(e,c)
	local code=c:GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(c9910681.disfilter,e:GetHandlerPlayer(),0,LOCATION_REMOVED,1,nil,code)
end
function c9910681.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(c9910681.disfilter,tp,0,LOCATION_REMOVED,1,nil,code)
end
function c9910681.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
