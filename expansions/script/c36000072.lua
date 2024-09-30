--渊猎的灵纹

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
    --ToHand
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tohtg)
	e1:SetOperation(s.tohop)
	c:RegisterEffect(e1)
	
	--SpDeckGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
end

--e1
--ToHand

function s.todfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToDeck()
end

function s.tohfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToHand() and not c:IsCode(id) and c:IsFaceupEx()
end

function s.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    
    if chk==0 then return Duel.IsExistingTarget(s.todfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tohfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_GRAVE+LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_GRAVE)
end

function s.tohop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tohfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) then return end
  
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tohfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsAbleToDeck() and aux.NecroValleyFilter()(tc)) then return end
	Duel.BreakEffect()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end

--e4
--SpDeckOrGrave

function s.spfilter(c,e,tp)
    return aux.IsCodeListed(c,cid) 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)  end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DISCARD,nil,1,0,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	    
	    if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)  then
	        Duel.BreakEffect()
	        Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	    end
	end
end
