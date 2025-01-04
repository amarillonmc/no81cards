--天气控制器
local cm,m=GetID()
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.hand)
	e0:SetDescription(aux.Stringid(m,3))
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.recon)
	e3:SetValue(LOCATION_HAND)
	c:RegisterEffect(e3)
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("Warning: Weather Control Device Detected.")
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	e1:SetTarget(cm.destg2)
	e1:SetOperation(cm.desop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.desfilter(c)
	return c:IsCode(12580477,14532163,69162969) and c:IsAbleToHand()
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<5 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.desfilter),tp,LOCATION_DECK,0,1,nil) end
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.desfilter),tp,LOCATION_DECK,0,nil)
	local ct=math.min(5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),#g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,ct,ct,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		Debug.Message("I am the Storm That is Approaching.")
		if e:GetHandler():GetFlagEffect(m)>0 then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) end
	end
end
function cm.recon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsReason(REASON_DESTROY)
end