-- 混沌统御
function c11771555.initial_effect(c)
	-- 属性转换
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771555,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11771555)
	e1:SetTarget(c11771555.tg1)
	e1:SetOperation(c11771555.op1)
	c:RegisterEffect(e1)
	-- 墓地盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771555,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11771556)
	e2:SetCondition(c11771555.con2)
	e2:SetTarget(c11771555.tg2)
	e2:SetOperation(c11771555.op2)
	c:RegisterEffect(e2)
end
-- 1
function c11771555.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c11771555.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11771555.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11771555.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11771555.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11771555.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	local newatt
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then
		newatt=ATTRIBUTE_DARK
	elseif tc:IsAttribute(ATTRIBUTE_DARK) then
		newatt=ATTRIBUTE_LIGHT
	else
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetTarget(c11771555.atttg)
	e1:SetValue(newatt)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11771555.atttg(e,c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup()
	else
		return true
	end
end
-- 2
function c11771555.filter2(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c11771555.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11771555.filter2,1,nil)
end
function c11771555.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11771555.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,c)
	end
end
