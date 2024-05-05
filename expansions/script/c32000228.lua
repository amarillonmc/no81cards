--红锈启动
local id=32000228
local zd=0xff6
function c32000228.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c32000228.e1tg)
	e1:SetOperation(c32000228.e1op)
	c:RegisterEffect(e1)
    --DestoryAndRemoveThen
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c32000228.e2tg)
	e2:SetOperation(c32000228.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--e1

function c32000228.e1adtohfilter(c)
	return c:IsSetCard(zd) and c:IsAbleToHand() and not c:IsCode(id)
end
function c32000228.e1adtockeck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

function c32000228.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000228.e1adtohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end

function c32000228.e1op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000228.e1adtohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000228.e1adtohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	
	if not (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,g)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IaAbaleToDeck,tp,LOCATION_HAND,0,1,1,g)
	Duel.SendtoDeck(g,nil,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end

--e2

function c32000228.espfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end



function c32000228.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end

function c32000228.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	
	local g2=Duel.GetMatchingGroup(c32000228.e2confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	
	if not (g2:GetClassCount(Card.GetCode)>=6 and Duel.SelectYesNo(p,aux.Stringid(id,2)))
	then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end


