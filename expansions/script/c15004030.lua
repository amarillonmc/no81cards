local m=15004030
local cm=_G["c"..m]
cm.name="南风诺托斯的感叹"
function cm.initial_effect(c)
	aux.AddCodeList(c,15004020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT-RESET_TOFIELD)
	e2:SetValue(LOCATION_DECKBOT)
	e:GetHandler():RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsCode(15004020) and c:IsAbleToHand()
end
function cm.tgfilter(c)
	return c:IsSetCard(0x6f30) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsEnvironment(15004020,tp,LOCATION_FZONE)
	if chk==0 then return ((Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and not b) or (b and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil))) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsEnvironment(15004020,tp,LOCATION_FZONE)
	if b and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(cm.indtg)
		e3:SetValue(aux.indoval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and not b then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end