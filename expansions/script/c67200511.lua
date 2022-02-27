--祝祷之珊海环
function c67200511.initial_effect(c)
	c:SetUniqueOnField(1,0,67200511)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c67200511.target)
	e1:SetOperation(c67200511.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c67200511.eqlimit)
	c:RegisterEffect(e2)	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x675))
	e3:SetCondition(c67200511.effcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
	--re equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200511,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c67200511.reqcon)
	e4:SetTarget(c67200511.reqtg)
	e4:SetOperation(c67200511.reqop)
	c:RegisterEffect(e4)
end
--
function c67200511.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67200511.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200511.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67200511.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c67200511.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c67200511.eqfilter(tc) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c67200511.eqlimit(e,c)
	return c:IsSetCard(0x675)
end
--
function c67200511.effcon(e)
	return e:GetHandler():GetEquipTarget()
end
--
function c67200511.reqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c67200511.reqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200511.reqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c67200511.reqfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c67200511.reqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67200511.reqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c67200511.reqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end

