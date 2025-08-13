--一般通过打牌人
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.drcost)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and e:GetHandler():IsReason(REASON_RULE)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)~=0 end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetTarget(s.efftg)
		e1:SetValue(aux.tgsval)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetValue(s.efilter)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.efftg(e,c)
	return c:GetControler()~=e:GetHandlerPlayer()
end
function s.efilter(e,ct)
	local tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	return e:GetHandlerPlayer()~=tp
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,1,REASON_EFFECT)<1 or not c:IsRelateToEffect(e) then return end
	if Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0 then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	else
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
