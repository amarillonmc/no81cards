--天启录G
function c21170008.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21170008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21170008.cost)
	e1:SetTarget(c21170008.tg)
	e1:SetOperation(c21170008.op)
	c:RegisterEffect(e1)
	c21170008.copy = e1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170008,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c21170008.tg2)
	e2:SetOperation(c21170008.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c21170008.con3)
	e3:SetOperation(c21170008.op3)
	c:RegisterEffect(e3)
end
function c21170008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c21170008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21170008)==0 end
	
end
function c21170008.q(c)
	return c:IsAbleToHand() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL and not c:IsCode(21170008)
end
function c21170008.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21170008,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g1=Duel.GetMatchingGroup(c21170008.q,tp,1,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c21170008.q),tp,0x10,0,nil)
	if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(21170008,0)) then
		Duel.Hint(3,tp,HINTMSG_ATOHAND)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(21170008,1)) then
		Duel.Hint(3,tp,HINTMSG_ATOHAND)
		local g=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21170008.w(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c21170008.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21170008.w,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c21170008.w,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c21170008.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c21170008.con3(e,tp,eg,ep,ev,re,r,rp)
	return r&(REASON_LINK|REASON_FUSION|REASON_SYNCHRO)>0
end
function c21170008.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x6917) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170008,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c21170008.tg2)
	e1:SetOperation(c21170008.op2)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end