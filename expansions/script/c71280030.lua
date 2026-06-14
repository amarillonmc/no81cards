--伪骸美杜莎
function c71280030.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--2X material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DOUBLE_XMATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c71280030.sxyzfilter)
	e1:SetValue(71280030)
	e1:SetCountLimit(1,71280030)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,71280030)
	e2:SetCondition(c71280030.eqcon)
	e2:SetTarget(c71280030.eqtg)
	e2:SetOperation(c71280030.eqop)
	c:RegisterEffect(e2)
end
function c71280030.sxyzfilter(e,c)
	return c:IsSetCard(0x48)
end
function c71280030.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c71280030.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (aux.IsCodeOrListed(c,97403510) or c:IsCode(23998625) or c:IsCode(47017574))
end
function c71280030.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71280030.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c71280030.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c71280030.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c71280030.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		if not Duel.Equip(tp,c,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(c71280030.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCondition(c71280030.negcon)
		e2:SetOperation(c71280030.negop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function c71280030.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c71280030.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and c:GetFlagEffect(71280030)==0
end
function c71280030.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(71280030,1)) then
		Duel.Hint(HINT_CARD,0,71280030)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(71280030,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71280030,4))
		local tc=e:GetHandler():GetEquipTarget()
		if tc then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end