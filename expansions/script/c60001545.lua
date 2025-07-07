--人偶剧场
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x625,LOCATION_ONFIELD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(2)
	e1:SetTarget(cm.Countdowntg)
	e1:SetOperation(cm.Countdownop)
	c:RegisterEffect(e1)
end
function cm.Countdowntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x625,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.Countdownop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		c:AddCounter(0x625,num)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60001511,1))
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.Countdowncost)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetCondition(cm.Countdowncon)
		c:RegisterEffect(e1)
		--damage
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCountLimit(1)
		e2:SetTarget(cm.dtg)
		e2:SetOperation(cm.dop)
		c:RegisterEffect(e2)
	end
end
function cm.Countdowncost(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function cm.Countdowncon(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end
function cm.filter(c)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end