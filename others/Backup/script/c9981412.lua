--魂之灵摆
function c9981412.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981412,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981412+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981412.cost1)
	e1:SetTarget(c9981412.target1)
	e1:SetOperation(c9981412.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9981412,1))
	e2:SetCost(c9981412.cost2)
	e2:SetTarget(c9981412.target2)
	e2:SetOperation(c9981412.activate2)
	c:RegisterEffect(e2)
end
function c9981412.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9981412.thfilter1(c)
	return c:IsSetCard(0x20f8,0x99,0x9f,0x98) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9981412.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9981412.thfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9981412.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981412.thfilter1,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if hg then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
function c9981412.costfilter(c)
	return c:IsSetCard(0x20f8,0x99,0x9f,0x98) and c:IsDiscardable()
end
function c9981412.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981412.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c9981412.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9981412.thfilter2(c)
	return c:IsSetCard(0x99,0xf2) and not c:IsCode(9981412) and c:IsAbleToHand()
end
function c9981412.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9981412.thfilter2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9981412.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981412.thfilter2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if hg then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end

