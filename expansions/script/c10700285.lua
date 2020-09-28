--传承之物的撰写
function c10700285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700285,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10700285.cost)
	e1:SetOperation(c10700285.activate)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700285,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(10700285,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10700285)
	e2:SetTarget(c10700285.tdtg)
	e2:SetOperation(c10700285.tdop)
	c:RegisterEffect(e2)   
end
function c10700285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700285.thfilter(c,atk)
	return c:IsSetCard(0x7c3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700285.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700285.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local hc=hg:GetFirst()
	if hc then
		Duel.SendtoHand(hc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hc)
	end
end
function c10700285.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700285.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end