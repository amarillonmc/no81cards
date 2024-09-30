--渊猎的巡视者

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
    --ToHand
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tohtg)
	e1:SetOperation(s.tohop)
	c:RegisterEffect(e1)
	
	--ToGraveSpAndTp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.togtg)
	e2:SetOperation(s.togop)
	c:RegisterEffect(e2)
	
end

--e1
--ToHand

function s.tohfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK,0,1,nil) and c:IsDiscardable(REASON_EFFECT) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DISCARD,c,1,0,0)
end

function s.tohop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tohfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	    Duel.SendtoHand(g,nil,REASON_EFFECT)
	    Duel.ConfirmCards(1-tp,g)
	    
	    local c=e:GetHandler()
	    if c:IsRelateToEffect(e) and c:IsDiscardable() then
	        Duel.BreakEffect()
	        Duel.SendtoGrave(c,REASON_DISCARD+REASON_EFFECT)
	    end
	end
end


--e2
--ToGraveRemoveAndToDeck

function s.togfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end

function s.todfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToDeck()
end

function s.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(s.todfilter,tp,LOCATION_GRAVE,0,1,nil) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.todfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
     Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,LOCATION_GRAVE)
     Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_GRAVE)
end

function s.togop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.togfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	    Duel.SendtoGrave(g,REASON_EFFECT)
	    
	    local tc=Duel.GetFirstTarget()
	    if tc:IsRelateToEffect(e) and tc:IsAbleToDeck() and aux.NecroValleyFilter()(tc) then
	        Duel.BreakEffect()
	        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	    end
	end
end




