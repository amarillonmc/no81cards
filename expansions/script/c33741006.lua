--闪耀的奇迹之星
local s,id,o=GetID()
function s.initial_effect(c)
	--Name becomes "Anifriends Serval"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetValue(33700055)
	c:RegisterEffect(e0)
	--to Deck and choose a card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.uniquefilter(c,g)
	return not g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
	if chk==0 then return g:GetCount()>0 and g:FilterCount(s.uniquefilter,nil,g)==g:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.oppfilter(c)
	return c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
	if g:GetCount()==0 or g:FilterCount(s.uniquefilter,nil,g)~=g:GetCount() then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end
	local canfield=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local op
	if canfield then
		op=Duel.SelectOption(1-tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
	else
		op=Duel.SelectOption(1-tp,aux.Stringid(id,1),aux.Stringid(id,2))
	end
	if op==0 then
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)
			s.public(e,tc)
		end
	elseif op==1 then
		if Duel.SendtoHand(tc,1-tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(tp,tc)
			s.public(e,tc)
			if Duel.IsExistingMatchingCard(s.oppfilter,tp,0,LOCATION_DECK,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local og=Duel.SelectMatchingCard(tp,s.oppfilter,tp,0,LOCATION_DECK,1,1,nil)
				local oc=og:GetFirst()
				if oc and Duel.SendtoHand(oc,tp,REASON_EFFECT)~=0 then
					Duel.ConfirmCards(1-tp,oc)
					s.public(e,oc)
				end
			end
		end
	else
		s.tofield(e,tp,tc)
	end
	Duel.ShuffleDeck(tp)
end
function s.public(e,tc)
	if tc:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.tofield(e,tp,tc)
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	else
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	tc:RegisterEffect(e1,true)
end
