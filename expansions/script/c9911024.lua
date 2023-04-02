--沧海姬的洗礼
function c9911024.initial_effect(c)
	aux.AddRitualProcGreater2(c,c9911024.ritual_filter,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c9911024.thtg)
	e1:SetOperation(c9911024.thop)
	c:RegisterEffect(e1)
end
function c9911024.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x6954)
end
function c9911024.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6954) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911024.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911024.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911024.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9911024.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9911024.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_WATER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			if Duel.SSet(tp,c)>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e3:SetValue(LOCATION_REMOVED)
				c:RegisterEffect(e3)
			end
		end
	end
end
