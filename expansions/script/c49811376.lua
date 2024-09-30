--日前流－三光竜
function c49811376.initial_effect(c)
    --level 7 dragon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811376,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811376)
    e1:SetCost(c49811376.pucost)
    e1:SetTarget(c49811376.putg)
    e1:SetOperation(c49811376.puop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811376,2))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,49811376)
    e2:SetCondition(c49811376.drcon)
    e2:SetTarget(c49811376.drtg)
    e2:SetOperation(c49811376.drop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811376,3))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCountLimit(1,49811376)
    e3:SetCost(c49811376.imcost)
    e3:SetTarget(c49811376.imtg)
    e3:SetOperation(c49811376.imop)
    c:RegisterEffect(e3)
end
function c49811376.pucost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function c49811376.pufilter(c)
    return c:IsLevel(7) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c49811376.putg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811376.pufilter,tp,LOCATION_DECK,0,1,nil) end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetDescription(66)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e:GetHandler():RegisterEffect(e1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811376.puop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c49811376.pufilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
        Duel.BreakEffect()
        local attr=tc:GetAttribute()
        if attr~=c:GetAttribute() then
            if Duel.SelectYesNo(tp,aux.Stringid(49811376,1)) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
                e1:SetValue(attr)
                c:RegisterEffect(e1)
            end
        end
    end
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e0:SetTargetRange(1,0)
    e0:SetDescription(aux.Stringid(49811376,4))
    e0:SetReset(RESET_PHASE+PHASE_END,1)
    Duel.RegisterEffect(e0,tp)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c49811376.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c49811376.splimit(e,c)
    return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c49811376.drfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c49811376.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811376.drfilter,1,nil)
end
function c49811376.tdfilter(c)
    return c:IsAbleToDeck()
end
function c49811376.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811376.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811376.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c49811376.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e0:SetTargetRange(1,0)
    e0:SetDescription(aux.Stringid(49811376,4))
    e0:SetReset(RESET_PHASE+PHASE_END,1)
    Duel.RegisterEffect(e0,tp)    
end
function c49811376.imfilter(c)
    return c:IsAbleToDeckAsCost() and c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c49811376.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c49811376.imfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and #g>0 end
    tg=g:Select(tp,1,1,nil)
    tg:AddCard(e:GetHandler())
    Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c49811376.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,49811376)==0 end
end
function c49811376.imop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
    e1:SetValue(c49811376.efilter)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterFlagEffect(tp,49811376,RESET_PHASE+PHASE_END,0,2)
    Duel.RegisterEffect(e1,tp)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e0:SetTargetRange(1,0)
    e0:SetDescription(aux.Stringid(49811376,4))
    e0:SetReset(RESET_PHASE+PHASE_END,1)
    Duel.RegisterEffect(e0,tp)
end
function c49811376.efilter(e,te,ev)
    return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_REMOVED
end