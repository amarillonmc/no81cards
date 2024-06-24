--神械邪核 腐蚀者
function c9910915.initial_effect(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,9910915)
	e2:SetCost(c9910915.thcost)
	e2:SetTarget(c9910915.thtg)
	e2:SetOperation(c9910915.thop)
	c:RegisterEffect(e2)
end
function c9910915.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,c)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9910682) and Duel.CheckLPCost(tp,2000)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910682,0))) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910915.thfilter(c)
	return c:IsLevelAbove(2) and c:IsSetCard(0xc954) and c:IsAbleToHand()
end
function c9910915.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c9910915.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910915.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Release(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910915.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(9910915,0)
		opval[off-1]=1
		off=off+1
	end
	ops[off]=aux.Stringid(9910915,1)
	opval[off-1]=2
	off=off+1
	ops[off]=aux.Stringid(9910915,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
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
