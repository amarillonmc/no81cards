--渊猎的工匠

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
    --Remove3FromDeckAndGrave
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--ToHandDeckAndTgToDeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.tohtg)
	e3:SetOperation(s.tohop)
	c:RegisterEffect(e3)
	
end

--e1
--Remove2FromDeckAndGrave

function s.rmfilter(c)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToRemove()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    if chk==0 then return g:CheckSubGroup(aux.dncheck,2,2) end    
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_DECK)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    if not g:CheckSubGroup(aux.dncheck,2,2) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.Remove(sg:Filter(aux.NecroValleyFilter,nil),POS_FACEUP,REASON_EFFECT)
end


--e3
--ToHandDeckEquipAndRemoveTg

function s.tohfilter(c)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToHand()
    and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.todfilter(c)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToDeck()
end

function s.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
   
    if chk==0 then return Duel.IsExistingTarget(s.todfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.todfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
     Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_GRAVE)
end

function s.tohop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    
    if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tohfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tohfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	
	if not (tc:IsRelateToEffect(e) and tc:IsAbleToDeck() and aux.NecroValleyFilter()(tc)) then return end
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end




