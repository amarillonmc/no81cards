--渊猎的重甲兵

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
    --RemoveFromDeckThenGraveToHand
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
	--ToGraveFromDeckThenRemoveToHand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.togtg)
	e2:SetOperation(s.togop)
	c:RegisterEffect(e2)
	
end

--e1
--RemoveFromDeckThen1ToHand

function s.rmfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToRemove()
    and not c:IsCode(id)
end

function s.togfilter(c)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToGrave()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end    
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_DECK+LOCATION_GRAVE)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tmg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(tmg,POS_FACEUP,REASON_EFFECT)
	
	if not (Duel.IsExistingMatchingCard(s.togfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,HINTMSG_TOGRAVE)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.togfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end


--e3
--ToGraveFromDeckThenRemoveToHand

function s.tohfilter(c)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToHand()
    and c:IsFaceupEx()
end

function s.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
   
    if chk==0 then return Duel.IsExistingMatchingCard(s.togfilter,tp,LOCATION_DECK,0,1,nil) end
    	
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
     Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,LOCATION_REMOVED)
end

function s.togop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    if not Duel.IsExistingMatchingCard(s.togfilter,tp,LOCATION_DECK,0,1,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local togg=Duel.SelectMatchingCard(tp,s.togfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(togg,REASON_EFFECT)
	
	if not (Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_REMOVED,0,1,c) and Duel.SelectYesNo(tp,HINTMSG_ATOHAND)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=Duel.SelectMatchingCard(tp,s.tohfilter,tp,LOCATION_REMOVED,0,1,1,c)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)

end




