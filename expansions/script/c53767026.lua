local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetTargetRange(0xff,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(s.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	c:CancelToGrave()
	if c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) else c:CancelToGrave(false) end
end
function s.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetActiveType()&0x20002==0x20002
end
function s.filter(c,tp)
	return c:GetType()&0x20002==0x20002 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.tgfilter(c,code)
	return c:GetType()&0x20002==0x20002 and c:IsAbleToGrave() and not c:IsCode(code)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Group.__add(g,c),2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode()):GetFirst()
		if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) and e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		end
	end
end
