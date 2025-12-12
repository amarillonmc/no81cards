--神域天使 至高代理
local m=70007777
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
	function cm.filter(c)
	return c:IsSetCard(0x1276) and c:IsAbleToHand() and not c:IsCode(m)
end
	function cm.filter2(c)
	return c:IsSetCard(0x1276) and c:IsAbleToGrave() and not c:IsCode(m)
end
	function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
	function cm.actfilter(c)
	return c:IsCode(70007773)
end
	function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	if Duel.GetMatchingGroupCount(cm.actfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
	function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m)
end