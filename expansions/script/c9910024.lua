--折纸使的振翼
function c9910024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9910024+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910024.condition)
	e1:SetCost(c9910024.cost)
	e1:SetTarget(c9910024.target)
	e1:SetOperation(c9910024.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9910024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x3950)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910024.cosfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3950) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c9910024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (not e:GetHandler():IsLocation(LOCATION_HAND)
		or Duel.IsExistingMatchingCard(c9910024.cosfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)) end
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910024.cosfilter),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		local fid=c:GetFieldID()
		local lab=tc:GetLocation()
		if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 and not tc:IsReason(REASON_REDIRECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(c9910024.retcon)
			e1:SetOperation(c9910024.retop)
			Duel.RegisterEffect(e1,tp)
			tc:RegisterFlagEffect(9910024,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc:RegisterFlagEffect(9910035,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,lab)
		end
	end
end
function c9910024.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910024)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910024.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local lab=tc:GetFlagEffectLabel(9910035)
	if lab==LOCATION_MZONE then
		Duel.ReturnToField(tc)
	end
	if lab==LOCATION_HAND then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if lab==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c9910024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910024.filter(c)
	return c:IsFaceup() and c:IsCode(9910034)
end
function c9910024.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9910024.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c9910024.filter,tp,LOCATION_ONFIELD,0,1,nil) then
		local g=Duel.GetMatchingGroup(c9910024.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		if g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(9910024,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,2,2,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
