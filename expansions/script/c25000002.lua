local m=25000002
local cm=_G["c"..m]
cm.name="都柏林人"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		cm[0]=Duel.DiscardDeck
		Duel.DiscardDeck=function(tp,ct,reason)
			local ct1,ct2=Duel.GetFlagEffect(0,m),Duel.GetFlagEffect(0,m+10000)
			if ct1>ct2 then
				local g=Duel.GetDecktopGroup(tp,ct)
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,reason)
			else return cm[0](tp,ct,reason) end
		end
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(m) then Duel.RegisterFlagEffect(0,m,0,0,0) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsOnField() then
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(function(e,c)return false end)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function cm.repfilter(c)
	return c:IsLocation(LOCATION_DECK+LOCATION_ONFIELD) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToHand()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1,ct2=Duel.GetFlagEffect(0,m),Duel.GetFlagEffect(0,m+10000)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil) and ct1>ct2 end
	Duel.RegisterFlagEffect(0,m+10000,0,0,0)
	local g=eg:Filter(cm.repfilter,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	return true
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
