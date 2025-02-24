--生命永恒
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,11900061)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --Back and Draw
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,id+10000)
    e2:SetCondition(function(e) 
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	e2:SetTarget(s.drtg) 
	e2:SetOperation(s.drop) 
	c:RegisterEffect(e2)
end
function s.thfi1ter(c) 
	return c:IsAbleToHand() and (c:IsCode(11900061) or (aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER)))   
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfi1ter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfi1ter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    local val=0
	if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc:IsLocation(LOCATION_DECK) then val=1 end
        if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
            Duel.ConfirmCards(1-tp,tc)
        end
	end
    if val==1 then Duel.ShuffleDeck(tp) end
    if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
        local rg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,11900061)
        if #rg>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
        	Duel.Draw(tp,1,REASON_EFFECT)
        end
	end
end