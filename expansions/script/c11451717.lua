--绛胧烈刃能态激发
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.tempfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.tffilter(c)
	return c:IsFaceup() and cm.tempfilter(c) and cm.retfilter(c)
end
function cm.retfilter(c)
	local p=c:GetPreviousControler()
	return Duel.GetLocationCount(p,LOCATION_MZONE)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tffilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,cm.tffilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:ResetFlagEffect(11451718)
		local rc=tc
		if tc:GetReasonEffect() and tc:GetReasonEffect():GetOwner() then rc=tc:GetReasonEffect():GetOwner() end
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(m)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.retop3)
		Duel.RegisterEffect(e1,0)
		Duel.RaiseEvent(tc,m,e,0,0,0,0)
		e1:Reset()
	end
end
function cm.retop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.exccon(e) or c:IsReason(REASON_DESTROY)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end
end