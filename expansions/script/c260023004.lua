--三つ子悪魔のケルベロス
function c260023004.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,260023004)
    e1:SetCondition(c260023004.drcon)
    e1:SetTarget(c260023004.drtg)
    e1:SetOperation(c260023004.drop)
    c:RegisterEffect(e1)
    
    --Link Summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260024004)
    e2:SetCost(c260023004.lspcost)
    e2:SetTarget(c260023004.lsptg)
    e2:SetOperation(c260023004.lspop)
    c:RegisterEffect(e2)
end
    

--【ドロー】
function c260023004.spfilter(c,e,tp)
    return c:IsCode(260023001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260023004.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and r==REASON_LINK and c:GetReasonCard():IsRace(RACE_FIEND)
end
function c260023004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c260023004.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local g=Duel.GetMatchingGroup(c260023004.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(260023004,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=g:Select(tp,1,1,nil)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end


--【リンク召喚】
function c260023004.lspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c260023004.lspfilter(c,e,tp)
    return c:IsSetCard(0x2045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and c:IsFaceup()
end
function c260023004.fselect(g,tp)
    return Duel.IsExistingMatchingCard(c260023004.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c260023004.lkfilter(c,g)
    return c:IsRace(RACE_FIEND) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c260023004.chkfilter(c,tp)
    return c:IsType(TYPE_LINK) and c:IsRace(RACE_FIEND) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c260023004.lsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 then return false end
        if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local cg=Duel.GetMatchingGroup(c260023004.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
        if #cg==0 then return false end
        local _,maxlink=cg:GetMaxGroup(Card.GetLink)
        if maxlink>ft then maxlink=ft end
        local g=Duel.GetMatchingGroup(c260023004.lspfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
        return g:CheckSubGroup(c260023004.fselect,1,maxlink,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c260023004.lspop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c260023004.lspfilter),tp,LOCATION_REMOVED,0,nil,e,tp)
    local cg=Duel.GetMatchingGroup(c260023004.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
    local _,maxlink=cg:GetMaxGroup(Card.GetLink)
    if ft>0 and maxlink then
        if maxlink>ft then maxlink=ft end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:SelectSubGroup(tp,c260023004.fselect,false,1,maxlink,tp)
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
        local tg=Duel.GetMatchingGroup(c260023004.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
        if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local rg=tg:Select(tp,1,1,nil)
            Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
        end
    end
end
