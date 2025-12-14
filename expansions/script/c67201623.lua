--长夜之复转
function c67201623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67201623+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c67201623.condition)
	e1:SetCost(c67201623.cost)
	e1:SetTarget(c67201623.target)
	e1:SetOperation(c67201623.activate)
	c:RegisterEffect(e1)  
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201623,2))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1000)
	e3:SetCondition(c67201623.gfcon)
	c:RegisterEffect(e3)  
end
function c67201623.gfcon(e)
	return e:GetHandler():IsSetCard(0x367f)
end
function c67201623.filter11(c)
	return c:IsSetCard(0x367f) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function c67201623.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67201623.filter11,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_HAND,0,1,nil)
end
function c67201623.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(67201623,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
	end
	e:SetLabel(spct)
	if not Duel.IsExistingMatchingCard(c67201623.filter11,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c67201623.filter11,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c67201623.filter11,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function c67201623.nbfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c)
end
function c67201623.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c67201623.nbfilter(chkc) and c~=chkc end
	if chk==0 then return Duel.IsExistingTarget(c67201623.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c67201623.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c67201623.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c67201623.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if tc:IsLocation(LOCATION_ONFIELD) then
			local spct=e:GetLabel()
			if spct>0 and c:IsRelateToEffect(e) and c:IsCanOverlay() and tc:IsCanOverlay() and Duel.IsExistingMatchingCard(c67201623.matfilter,tp,LOCATION_MZONE,0,1,tc) and Duel.SelectYesNo(tp,aux.Stringid(67201623,2)) then
				Duel.BreakEffect()
				c:CancelToGrave()
				local ttc=Duel.SelectMatchingCard(tp,c67201623.matfilter,tp,LOCATION_MZONE,0,1,1,tc):GetFirst()
				if c:IsRelateToEffect(e) and not ttc:IsImmuneToEffect(e) then
					local og=tc:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(ttc,Group.FromCards(c,tc))
				end  
			end
		end
	end
end
--

