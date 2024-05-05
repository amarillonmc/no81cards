--星核猎手·蛊谧蛛网
function c78310585.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,78310585)
	e1:SetCost(c78310585.cost)
	e1:SetTarget(c78310585.target)
	e1:SetOperation(c78310585.operation)
	c:RegisterEffect(e1)
end
function c78310585.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c78310585.cfilter(c,tp)
	local b1=Duel.IsExistingMatchingCard(c78310585.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
	local b2=Duel.IsExistingMatchingCard(c78310585.rmfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
		and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil)
	return c:IsSetCard(0x747) and not c:IsPublic() and (b1 or b2)
end
function c78310585.thfilter(c,code)
	return c:IsSetCard(0x747) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c78310585.rmfilter(c,code)
	return c:IsSetCard(0x747) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c78310585.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c78310585.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cc=Duel.SelectMatchingCard(tp,c78310585.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,cc)
	Duel.RaiseEvent(cc,EVENT_CUSTOM+78313585,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
	local b1=Duel.IsExistingMatchingCard(c78310585.thfilter,tp,LOCATION_DECK,0,1,nil,cc:GetCode())
	local b2=Duel.IsExistingMatchingCard(c78310585.rmfilter,tp,LOCATION_GRAVE,0,1,nil,cc:GetCode())
		and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil)
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(78310585,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(78310585,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetTargetCard(cc)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,c78310585.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,cc:GetCode())
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function c78310585.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		local cc=Duel.GetFirstTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c78310585.thfilter,tp,LOCATION_DECK,0,1,1,nil,cc:GetCode())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
