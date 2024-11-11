local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(3,id)
	e2:SetTarget(s.dttg)
	e2:SetOperation(s.dtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(s.eqlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x30)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x30)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function s.dttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_EQUIP) and chkc~=e:GetHandler() end
	local eq=e:GetHandler():GetEquipTarget()
	if chk==0 then return eq and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_EQUIP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),TYPE_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local ec=c:GetEquipTarget()
		if not ec then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		ec:RegisterEffect(e2)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
	return c:IsSetCard(0x30) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
