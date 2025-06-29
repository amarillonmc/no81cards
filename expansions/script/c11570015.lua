--翼冠龙·末名之香缇欧拉斯
function c11570015.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11570015,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e1:SetCountLimit(1,11570015)
	e1:SetCost(c11570015.tdcost)
	e1:SetTarget(c11570015.tdtg)
	e1:SetOperation(c11570015.tdop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11570015+10000000)
	e2:SetCondition(c11570015.rmcon)
	e2:SetTarget(c11570015.rmtg)
	e2:SetOperation(c11570015.rmop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetCondition(c11570015.atkcon)
	c:RegisterEffect(e3)
end
function c11570015.costfilter(c,ec,tp)
	return c:IsSetCard(0x810) and c:IsFaceup() and (c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED)) and Duel.IsExistingMatchingCard(c11570015.tdfilter,tp,LOCATION_HAND+0x30,0,1,Group.FromCards(c,ec))
end
function c11570015.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11570015.costfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,c,tp) and (c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11570015.costfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,c,c,tp)
	g:AddCard(c)
	local rg=g:Filter(Card.IsLocation,1,nil,LOCATION_REMOVED)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RETURN)
	g:Sub(rg)
	Duel.SendtoGrave(g,REASON_COST)
end
function c11570015.tdfilter(c)
	return c:IsSetCard(0x810) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c11570015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11570015.cfilter(c,loc)
	return c:IsSetCard(0x810) and (loc==LOCATION_HAND and c:IsAbleToHand() or loc==LOCATION_GRAVE and c:IsAbleToGrave() or loc==LOCATION_REMOVED and c:IsAbleToRemove())
end
function c11570015.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) else Duel.HintSelection(Group.FromCards(tc)) end
	local loc=tc:GetLocation()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_DECK) then return end
	if Duel.IsExistingMatchingCard(c11570015.cfilter,tp,LOCATION_DECK,0,1,nil,loc) and Duel.SelectYesNo(tp,aux.Stringid(11570015,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c11570015.cfilter,tp,LOCATION_DECK,0,1,1,nil,loc)
		if loc==LOCATION_HAND then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif loc==LOCATION_GRAVE then
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif loc==LOCATION_REMOVED then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11570015.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c11570015.rmfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToRemove()
end
function c11570015.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570015.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11570015.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570015.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c11570015.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570015.atkcon(e)
	return not Duel.IsExistingMatchingCard(c11570015.chkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
