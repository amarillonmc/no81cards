--AK-追光的深靛
function c82568083.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,82568083)
	e1:SetCost(c82568083.cost)
	e1:SetTarget(c82568083.target)
	e1:SetOperation(c82568083.activate)
	c:RegisterEffect(e1)
end
function c82568083.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c82568083.filter(c)
	return (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x825)) or (c:IsSetCard(0x46,0x828) and c:IsType(TYPE_SPELL)) and c:IsAbleToHand()
end
function c82568083.Pfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x825)
end
function c82568083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568083.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c82568083.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(c82568083.Pfilter,1,nil) then res=res+0x1 end
	if g:IsExists(Card.IsSetCard,1,nil,0x46) then res=res+0x2 end
	if g:IsExists(Card.IsSetCard,1,nil,0x828) then res=res+0x4 end
	return res~=0x1 and res~=0x2 and res~=0x4
end
function c82568083.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c82568083.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,c82568083.check,false,1,2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end