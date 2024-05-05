--武色残骸

local id=32000438
local zd=0x3c5
function c32000438.initial_effect(c)

    --activeAd2FromGAndR
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c32000438.e1tg)
	e1:SetOperation(c32000438.e1op)
	c:RegisterEffect(e1)
	
	
	--RetAndDrawWhenDestroyedOrSendToGrave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(c32000438.e2tg)
	e2:SetOperation(c32000438.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	
	
end



--e1

function c32000438.e1tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function c32000438.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000438.e1tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000438.e1op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000438.e1tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000438.e1tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	
end


--e2

function c32000438.e2todfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToDeck()
end

function c32000438.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000438.e2todfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end

function c32000438.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000438.e2todfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) ) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c32000438.e2todfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)

	Duel.SendtoDeck(g,nil,3,REASON_EFFECT)
	
	Duel.Draw(tp,1,REASON_EFFECT)
end






