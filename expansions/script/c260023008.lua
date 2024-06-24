--地獄CEOのルシファー
function c260023008.initial_effect(c)
    
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,260023008)
    e1:SetCost(c260023008.thcost)
    e1:SetTarget(c260023008.thtg)
    e1:SetOperation(c260023008.thop)
    c:RegisterEffect(e1)
    --Link Summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260024008)
    e2:SetCost(c260023008.lspcost)
    e2:SetTarget(c260023008.lsptg)
    e2:SetOperation(c260023008.lspop)
    c:RegisterEffect(e2)
end
    

--【サーチ】
function c260023008.spfilter(c,e,tp)
    return c:IsCode(260023001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260023008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c260023008.thfilter(c)
    return c:IsCode(260023020) and c:IsAbleToHand()
end
function c260023008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260023008.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c260023008.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260023008.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local g=Duel.GetMatchingGroup(c260023008.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(260023008,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=g:Select(tp,1,1,nil)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end


--【リンク召喚】
function c260023008.lspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c260023008.lspfilter(c,e,tp)
    return c:IsSetCard(0x2045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and c:IsFaceup()
end
function c260023008.fselect(g,tp)
    return Duel.IsExistingMatchingCard(c260023008.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c260023008.lkfilter(c,g)
    return c:IsRace(RACE_FIEND) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c260023008.chkfilter(c,tp)
    return c:IsType(TYPE_LINK) and c:IsRace(RACE_FIEND) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c260023008.lsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 then return false end
        if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local cg=Duel.GetMatchingGroup(c260023008.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
        if #cg==0 then return false end
        local _,maxlink=cg:GetMaxGroup(Card.GetLink)
        if maxlink>ft then maxlink=ft end
        local g=Duel.GetMatchingGroup(c260023008.lspfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
        return g:CheckSubGroup(c260023008.fselect,1,maxlink,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c260023008.lspop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c260023008.lspfilter),tp,LOCATION_REMOVED,0,nil,e,tp)
    local cg=Duel.GetMatchingGroup(c260023008.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
    local _,maxlink=cg:GetMaxGroup(Card.GetLink)
    if ft>0 and maxlink then
        if maxlink>ft then maxlink=ft end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:SelectSubGroup(tp,c260023008.fselect,false,1,maxlink,tp)
        if not sg then return end
        local tc=sg:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            tc:RegisterEffect(e2)
            tc=sg:GetNext()
        end
        Duel.SpecialSummonComplete()
        local og=Duel.GetOperatedGroup()
        Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
        if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
        local tg=Duel.GetMatchingGroup(c260023008.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
        if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local rg=tg:Select(tp,1,1,nil)
            Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
        end
    end
end
