--虚毒之光
local m=33700713
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
	--dam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(cm.damcon1)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(cm.damcon2)
	e3:SetOperation(cm.damop2)
	c:RegisterEffect(e3)
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCounter(tp,1,1,0x144b)>0
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCounter(tp,0,1,0x144b)>0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCounter(tp,1,1,0x144b)
	if ct>0 then 
	   Duel.Hint(HINT_CARD,0,m)
	   Duel.Damage(1-tp,ct*50,REASON_EFFECT)
	end
end
function cm.damop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCounter(tp,0,1,0x144b)
	if ct>0 and Duel.GetTurnPlayer()~=tp then 
	   Duel.Hint(HINT_CARD,0,m)
	   Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end
function cm.filter(c)
	return not c:IsCode(m) and c:IsSetCard(0x144b) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end