--借符『大穴牟迟大人的药』
function c11200070.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c11200070.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,11200070+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c11200070.tg2)
	e2:SetOperation(c11200070.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c11200070.con3)
	e3:SetTarget(c11200070.tg3)
	e3:SetOperation(c11200070.op3)
	c:RegisterEffect(e3)
--
end
--
c11200070.xig_ihs_0x133=1
--
function c11200070.cfilter1(c)
	return not (c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function c11200070.con1(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c11200070.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c11200070.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c11200070.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_EQUIP_LIMIT)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetValue(c11200070.val2_1)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2_1)
		if Duel.SelectYesNo(tp,aux.Stringid(11200070,0)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_2:SetCode(EFFECT_DISABLE)
			e2_2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2_2)
		end
		c:CancelToGrave()
	else
		c:CancelToGrave(false)
	end
end
--
function c11200070.val2_1(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
--
function c11200070.cfilter3(c,tp)
	return c:IsSetCard(0x621) and c:IsType(TYPE_MONSTER)
end
function c11200070.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200070.cfilter3,1,nil)
		and not eg:IsContains(e:GetHandler())
end
--
function c11200070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c11200070.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
--
