--永夏的花海
function c9910970.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910970.flag)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove & to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910970,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c9910970.rmtg)
	e2:SetOperation(c9910970.rmop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910970,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c9910970.thcost)
	e3:SetTarget(c9910970.thtg)
	e3:SetOperation(c9910970.thop)
	c:RegisterEffect(e3)
end
function c9910970.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910970.rmfilter(c,tp)
	return c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910970.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910970.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)+2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9910970.thfilter1(c)
	return c:IsSetCard(0x5954) and c:IsAbleToHand()
end
function c9910970.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c9910970.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
	local rc=rg:GetFirst()
	if rc and rc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,rc) end
	if not rc or Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)==0 or not rc:IsLocation(LOCATION_REMOVED) then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)+2
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c9910970.thfilter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910970,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c9910970.thfilter1,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end
function c9910970.tdfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsReason(REASON_EFFECT) and c:IsAbleToDeckOrExtraAsCost()
end
function c9910970.ccfilter(c)
	return bit.band(c:GetType(),0x7)
end
function c9910970.fselect(g)
	return g:GetClassCount(c9910970.ccfilter)==g:GetCount()
end
function c9910970.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910970.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c9910970.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c9910970.fselect,false,3,3)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.ConfirmCards(1-tp,sg)
end
function c9910970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910970.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
