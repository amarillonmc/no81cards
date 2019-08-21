--折纸使的振翼
function c9910024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
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
function c9910024.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x950)
end
function c9910024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910024.confilter,tp,LOCATION_PZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910024.cosfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x950) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c9910024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		if not Duel.IsExistingMatchingCard(c9910024.cosfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
		then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local c=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910024.cosfilter),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		local lab=c:GetLocation()
		if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(lab)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c9910024.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9910024.retop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local tc=e:GetLabelObject()
	if lab==LOCATION_MZONE then
		Duel.ReturnToField(tc)
	end
	if lab==LOCATION_HAND then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
	if lab==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c9910024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9910024.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,aux.ExceptThisCard(e))
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
