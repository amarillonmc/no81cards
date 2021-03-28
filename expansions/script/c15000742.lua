local m=15000742
local cm=_G["c"..m]
cm.name="噩梦茧机牵丝"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--return monster
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,15000742)
	e1:SetCondition(cm.mcon)
	e1:SetTarget(cm.mtg)
	e1:SetOperation(cm.mop)
	c:RegisterEffect(e1)
	--return Spell/Trap
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,15000743)
	e2:SetCondition(cm.scon)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsSetCard(0x6f38) and c:IsType(TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.mrtfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.mfilter,1,nil)
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.mrtfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.mrtfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.mrtfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.srtfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)  
	return ((e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsSetCard(0x6f38) and re:IsActivated()) or (e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x6f38))) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and cm.srtfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.srtfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.srtfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end