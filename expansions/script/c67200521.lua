--眷属之珊海环
function c67200521.initial_effect(c)
	c:SetUniqueOnField(1,0,67200521)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c67200521.target)
	e1:SetOperation(c67200521.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c67200521.eqlimit)
	c:RegisterEffect(e2)	 
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,67200521)
	e3:SetTarget(c67200521.cttg)
	e3:SetOperation(c67200521.ctop)
	c:RegisterEffect(e3)  
	--re equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200521,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c67200521.reqcon)
	e4:SetTarget(c67200521.reqtg)
	e4:SetOperation(c67200521.reqop)
	c:RegisterEffect(e4)
end
--
function c67200521.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200521.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67200521.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200521.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67200521.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c67200521.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c67200521.eqfilter(tc) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c67200521.eqlimit(e,c)
	return c:IsSetCard(0x675)
end
--
function c67200521.filter(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and c:IsSetCard(0x675) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c67200521.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200521.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200521.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function c67200521.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c67200521.filter,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(c67200521.filter,tp,0,LOCATION_MZONE,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c67200521.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(1-tp,c67200521.filter,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	Duel.SwapControl(c1,c2,0,0)
end
--
function c67200521.reqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c67200521.reqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675)
end
function c67200521.reqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c67200521.reqfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c67200521.reqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67200521.reqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c67200521.reqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end


