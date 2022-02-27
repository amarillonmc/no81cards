--强化之珊海环
function c67200501.initial_effect(c)
	c:SetUniqueOnField(1,0,67200501)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c67200501.target)
	e1:SetOperation(c67200501.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c67200501.eqlimit)
	c:RegisterEffect(e2)  
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3) 
	--re equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200501,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	--e4:SetCountLimit(1,67200501)
	e4:SetCondition(c67200501.reqcon)
	e4:SetTarget(c67200501.reqtg)
	e4:SetOperation(c67200501.reqop)
	c:RegisterEffect(e4)
end
function c67200501.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67200501.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200501.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67200501.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c67200501.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c67200501.eqfilter(tc) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c67200501.eqlimit(e,c)
	return c:IsSetCard(0x675)
end
--
function c67200501.reqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c67200501.reqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200501.reqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c67200501.reqfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c67200501.reqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67200501.reqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c67200501.reqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end

