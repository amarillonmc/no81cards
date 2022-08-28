local m=15004242
local cm=_G["c"..m]
cm.name="天星·陵薮层岩"
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.dcon)
	e2:SetTarget(cm.dtg)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetCounter(0)~=0
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	local tc=Duel.GetFirstTarget()
	local count=tc:GetCounter(0x1f31)
	if tc:GetCounter(0)~=0 and tc:IsRelateToEffect(e) then
		tc:RemoveCounter(tp,0,0,REASON_EFFECT)
	end
	if count~=0 and tc:GetCounter(0x1f31)==0 and Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end