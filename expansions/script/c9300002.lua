--无限魔力宝石
function c9300002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9300002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9300002.target)
	e1:SetOperation(c9300002.operation)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9300002)
	e2:SetCost(c9300002.thcost)
	e2:SetTarget(c9300002.thtg)
	e2:SetOperation(c9300002.thop)
	c:RegisterEffect(e2)
end
function c9300002.thfilter(c)
	return c:IsCode(9300002) and c:IsAbleToHand()
end
function c9300002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9300002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9300002.cfilter(c)
	return c:IsCode(9300002) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c9300002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9300002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.GetMatchingGroupCount(c9300002.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9300002,0)) then
			while ct>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,nil,0x1,1):GetFirst()
				if not tc then break end
				tc:AddCounter(0x1,1)
				ct=ct-1
			end
		end
	end
end
function c9300002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9300002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9300002.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
