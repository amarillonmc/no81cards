--黑之裁判<追猎者>琳达梅尔
function c95101187.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2,nil,nil,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101187,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95101187)
	e1:SetCost(c95101187.thcost)
	e1:SetTarget(c95101187.thtg)
	e1:SetOperation(c95101187.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101187,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c95101187.negcon)
	e2:SetTarget(c95101187.negtg)
	e2:SetOperation(c95101187.negop)
	c:RegisterEffect(e2)
end
function c95101187.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c95101187.thfilter(c,chk)
	return c:IsSetCard(0xbbb) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101187.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101187.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101187.setfilter(c)
	return c:IsSetCard(0xbbb) and c:IsSSetable()
end
function c95101187.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101187.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_GRAVE,5,nil,TYPE_MONSTER) and Duel.IsExistingMatchingCard(c95101187.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(95101187,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=Duel.SelectMatchingCard(tp,c95101187.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
		end
	end
end
function c95101187.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsRace,nil,RACE_PLANT)~=0
end
function c95101187.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_GRAVE and Duel.IsChainDisablable(ev)
end
function c95101187.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c95101187.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
