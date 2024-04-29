local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_FUSION)
end
function s.rfilter(c,chk)
	return c:IsFaceupEx() and c:GetType()&0x20002==0x20002 and (c:IsAbleToDeck() or chk and c:IsAbleToHand())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.rfilter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(s.rfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,check) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.rfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,check)
	if not check then Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0) end
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local check=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsAbleToHand()
		local res=0
		if check and Duel.SelectOption(tp,1190,1193)==0 then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_HAND) then res=0 end
			Duel.ConfirmCards(1-tp,tc)
		else
			res=Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then res=0 end
		end
		if res>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	c:CancelToGrave()
	if c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) else c:CancelToGrave(false) end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and tc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
