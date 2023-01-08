--神械邪核 腐蚀者
function c9910915.initial_effect(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910915)
	e2:SetCost(c9910915.thcost)
	e2:SetTarget(c9910915.thtg)
	e2:SetOperation(c9910915.thop)
	c:RegisterEffect(e2)
end
function c9910915.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9910915.thfilter(c)
	return c:IsSetCard(0xc954) and not c:IsCode(9910915) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910915.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910915.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910915.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xc954)
end
function c9910915.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910915.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if not Duel.IsExistingMatchingCard(c9910915.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910915.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910915.discon)
		e2:SetOperation(c9910915.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910915.distg)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9910915.disfilter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function c9910915.distg(e,c)
	local code=c:GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(c9910915.disfilter,e:GetHandlerPlayer(),0,LOCATION_REMOVED,1,nil,code)
end
function c9910915.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(c9910915.disfilter,tp,0,LOCATION_REMOVED,1,nil,code)
end
function c9910915.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
