--未完の物語
function c260013027.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c260013027.descon)
    e1:SetCost(c260013027.descost)
    e1:SetTarget(c260013027.destg)
    e1:SetOperation(c260013027.desop)
    c:RegisterEffect(e1)
    
    --sp summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,260013027)
    e2:SetCost(c260013027.spcost)
    e2:SetTarget(c260013027.sptg)
    e2:SetOperation(c260013027.spop)
    c:RegisterEffect(e2)
    
    --act in hand
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e3)

end
    
--【破壊】
function c260013027.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x943) and c:IsType(TYPE_MONSTER)
end
function c260013027.desfilter(c)
    return c:IsSetCard(0x943) and c:IsAbleToGraveAsCost() and not c:IsCode(260013027)
end
function c260013027.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c260013027.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c260013027.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
    if chk==0 then return Duel.IsExistingMatchingCard(c260013027.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
    if Duel.GetTurnPlayer()==1-tp then
        if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
            Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
        end
    end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c260013027.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c260013027.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c260013027.desfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c260013027.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end


--【特殊召喚】
function c260013027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c260013027.tdfilter(c)
    return c:IsSetCard(0x943) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function c260013027.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(7) and c:IsRace(RACE_SPELLCASTER)
end
function c260013027.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c260013027.tdfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260013027.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c260013027.tdfilter,tp,LOCATION_GRAVE,0,3,nil) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c260013027.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
    if chk==0 then return Duel.IsExistingMatchingCard(c260013027.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c260013027.spop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local g=Duel.GetMatchingGroup(c260013027.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(260013027,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end