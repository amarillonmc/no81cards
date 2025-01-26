--审讯时间
function c19209549.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19209549)
	e1:SetCondition(c19209549.condition)
	e1:SetTarget(c19209549.target)
	e1:SetOperation(c19209549.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209550)
	e2:SetCost(c19209549.pencost)
	e2:SetTarget(c19209549.pentg)
	e2:SetOperation(c19209549.penop)
	c:RegisterEffect(e2)
end
function c19209549.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209549.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209549.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19209549.cfilter(c,tp)
	return c:IsSetCard(0x3b50) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsFaceup() and Duel.IsExistingMatchingCard(c19209549.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c19209549.thfilter(c,code)
	return aux.IsCodeListed(c,code) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c19209549.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c19209549.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c19209549.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c19209549.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19209549.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209549.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c19209549.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c19209549.penfilter(c)
	return c:IsCode(19209511) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c19209549.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c19209549.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c19209549.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c19209549.penfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
