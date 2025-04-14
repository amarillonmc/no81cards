--天启录E
function c21170006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21170006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21170006.tg)
	e1:SetOperation(c21170006.op)
	c:RegisterEffect(e1)
	c21170006.copy = e1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170006,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c21170006.tg2)
	e2:SetOperation(c21170006.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c21170006.con3)
	e3:SetOperation(c21170006.op3)
	c:RegisterEffect(e3)
end
function c21170006.q(c)
	return c:IsSetCard(0x6917) and c:IsAbleToHand() and c:GetOriginalType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
end
function c21170006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170006.q,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21170006.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21170006.q),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #tg>0 then
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	end
end
function c21170006.w(c)
	return c:IsFaceupEx() and c:GetType()==TYPE_SPELL and c:IsSetCard(0x6917) and c:IsAbleToHand()
end
function c21170006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21170006.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21170006.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c21170006.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c21170006.con3(e,tp,eg,ep,ev,re,r,rp)
	return r&(REASON_LINK|REASON_FUSION|REASON_SYNCHRO)>0
end
function c21170006.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x6917) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170006,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c21170006.tg2)
	e1:SetOperation(c21170006.op2)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end