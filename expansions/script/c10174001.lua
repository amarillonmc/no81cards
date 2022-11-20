--让我康康！
function c10174001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10174001.target)
	e1:SetOperation(c10174001.activate)
	c:RegisterEffect(e1)	
end
function c10174001.cfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c10174001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c10174001.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10174001.cfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,c10174001.cfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c10174001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() or tc:IsControler(tp) then return end
	Duel.ConfirmCards(tp,tc)
	if not tc:IsCode(ac) and c:IsRelateToEffect(e) and c:IsAbleToDeck() then
	   c:CancelToGrave()
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	if tc:IsCode(ac) and tc:IsAbleToHand() and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and (tc:IsLocation(LOCATION_HAND) or (tc:IsLocation(LOCATION_EXTRA) and tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK))) and c:IsRelateToEffect(e) and c:IsCanTurnSet() then
	   c:CancelToGrave()
	   Duel.ChangePosition(c,POS_FACEDOWN)
	   Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)  
	end
end
