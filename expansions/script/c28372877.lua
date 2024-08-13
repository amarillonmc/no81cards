--L'Antica秘密基地
function c28372877.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c28372877.activate)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c28372877.indescon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c28372877.rmlimit)
	e2:SetCondition(c28372877.indescon)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c28372877.drcon)
	e3:SetValue(c28372877.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c28372877.tdtg)
	e5:SetOperation(c28372877.tdop)
	c:RegisterEffect(e5)
end
function c28372877.filter(c)
	return c:IsSetCard(0x285) and c:IsAbleToDeck()
end
function c28372877.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28372877.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c28372877.filter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c28372877.thfilter,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>1 and Duel.SelectYesNo(tp,aux.Stringid(28372877,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c28372877.indescon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=3000
end
function c28372877.rmlimit(e,c,tp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function c28372877.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x285)
end
function c28372877.drcon(e)
	local p=e:GetHandlerPlayer()
	return Duel.GetLP(p)<=3000 and Duel.IsExistingMatchingCard(c28372877.cfilter,p,LOCATION_MZONE,0,1,nil)
end
function c28372877.damval(e,re,val,r,rp,rc)
	return 0
end
function c28372877.tdfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c28372877.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28372877.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28372877.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c28372877.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28372877.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c28372877.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28372877.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local tc=Duel.GetFirstTarget()
	if ct>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	end
end
