local m=15000668
local cm=_G["c"..m]
cm.name="报丧泣语·荒海"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000661)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,15000668)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,15010668)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	if cm.counter==nil then
		cm.counter=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function cm.thfilter(c)
	return ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)) or (c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD))) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD,1,1,nil)
	if g:GetFirst():GetLocation()==LOCATION_GRAVE then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsReason(REASON_COST) and tc:GetReasonEffect():IsActivated() and ((tc:GetReasonEffect():IsActiveType(TYPE_MONSTER) and tc:GetReasonEffect():GetHandler():IsAttribute(ATTRIBUTE_WATER)) or tc:GetReasonEffect():GetHandler():IsCode(15000661)) then
			cm.counter=cm.counter+1
		end
		tc=eg:GetNext()
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	cm.counter=0
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and ((re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)) or re:GetHandler():IsCode(15000661))
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.drcon)
	e1:SetOperation(cm.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.counter>0
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,cm.counter,REASON_EFFECT)
end