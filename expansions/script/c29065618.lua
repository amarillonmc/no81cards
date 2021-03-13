--花火昙
function c29065618.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065618,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,29065618)
	e1:SetCost(c29065618.cost)
	e1:SetTarget(c29065618.target)
	e1:SetOperation(c29065618.operation)
	c:RegisterEffect(e1)
end
function c29065618.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c29065618.filter(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsAbleToHand()
end
function c29065618.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local id=Duel.GetTurnCount()
	local loc=LOCATION_GRAVE+LOCATION_REMOVED 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(loc) and c29065618.filter(chkc,id) end
	if chk==0 then return Duel.IsExistingTarget(c29065618.filter,tp,loc,loc,1,nil,id) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c29065618.filter,tp,loc,loc,1,1,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
end
function c29065618.locfilter(c,sp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(sp)
end
function c29065618.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(c29065618.locfilter,nil,tp)
	if ct>0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
	end
end
