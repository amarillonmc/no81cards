--武色熔铸

local id=32000440
local zd=0x3c5
function c32000440.initial_effect(c)

    --activeToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c32000440.e1con)
	e1:SetTarget(c32000440.e1tg)
	e1:SetOperation(c32000440.e1op)
	c:RegisterEffect(e1)
	
	--Return4ToDeckAndDarw1ByReturnSelf
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(c32000440.e2cost)
	e2:SetTarget(c32000440.e2tg)
	e2:SetOperation(c32000440.e2op)
	c:RegisterEffect(e2)
	
end



--e1

function c32000440.e1togfilter(c)
    return c:IsSetCard(zd) and c:IsFaceup() and c:IsAbleToGraveAsCost(REASON_RETURN)
end

function c32000440.e1confilter(c)
    return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsSetCard(zd)
end

function c32000440.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c32000440.e1togfilter,tp,LOCATION_REMOVED,0,3,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RETURN)
	local g=Duel.SelectMatchingCard(tp,c32000440.e1togfilter,tp,LOCATION_REMOVED,0,3,3,nil)
   Duel.SendtoGrave(tp,g,nil,REASON_COST+REASON_RETURN+REASON_EFFECT)
end

function c32000440.e1con(e,tp,eg,ep,ev,re,r,rp,chk)
    return Duel.IsExistingMatchingCard(c32000440.e1confilter,tp,LOCATION_MZONE,0,1,nil) 
end

function c32000440.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_ONFIELD)
end

function c32000440.e1op(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	
end


--e2

function c32000440.e2todfilter(c)
    return c:IsSetCard(zd) and c:IsFaceup() and c:IsAbleToDeck()
end

function c32000440.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost(REASOM_RETURN) end
    Duel.SendtoGrave(c,nil,REASON_RETURN+REASON_EFFECT+REASON_COST)
end

function c32000440.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c32000440.e2todfilter,tp,LOCATION_REMOVED,0,1,c) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,6,c) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,6,tp,LOCATION_REMOVED)
end

function c32000440.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000440.e2todfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,6,nil)) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c32000440.e2todfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,5,5,g)
	Duel.SendtoDeck(g+g2,nil,3,REASON_EFFECT)
	
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end




