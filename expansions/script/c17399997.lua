-- 后悔 
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)

	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCondition(s.oppcon)
	e2:SetTarget(s.opptg)
	e2:SetOperation(s.oppop)
	c:RegisterEffect(e2)
end
function s.filter(c,tp)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function s.namefilter(c,code)
	return c:IsFaceupEx() and c:IsCode(code)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local code=g:GetFirst():GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(s.endop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.confirmfilter(c,code)
	return c:IsCode(code)
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.confirmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,code)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	local fdg=g:Filter(Card.IsFacedown,nil)
	if #fdg>0 then
		Duel.ConfirmCards(tp,fdg)
		Duel.ConfirmCards(1-tp,fdg)
	end
	Duel.HintSelection(g)
	local count=#g
	local target_num = count * 3 
	local field_count = Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) 
	local actual_return = math.min(target_num, field_count)

	if actual_return > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,actual_return,actual_return,nil)
		if #dg>0 then
			Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.oppcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.opptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function s.oppop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp, aux.Stringid(id,2)) then
		s.thop(e,1-tp,eg,ep,ev,re,r,rp)
	end
end