--A・ジェネクス・コライダー
function c49811191.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811191,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811191)
    e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCost(c49811191.spcost)
    e1:SetTarget(c49811191.sptg)
    e1:SetOperation(c49811191.spop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811191,2))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1,49811192)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c49811191.drcon)
    e2:SetTarget(c49811191.drtg)
    e2:SetOperation(c49811191.drop)
    c:RegisterEffect(e2)
end
function c49811191.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c49811191.spfilter(c,e,tp)
    return c:IsCode(73783043) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811191.thfilter(c)
    return c:IsSetCard(0x2) and c:IsAbleToHand()
end
function c49811191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(c49811191.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c49811191.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811191.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return 
            end
            local sg=Duel.GetMatchingGroup(c49811191.thfilter,tp,LOCATION_DECK,0,nil)
            if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(49811191,1)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local tag=sg:Select(tp,1,1,nil)
                Duel.SendtoHand(tag,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tag)
            end
        end        
    end
end
function c49811191.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811191.drfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c49811191.drfilter(c)
    return c:IsFaceup() and c:IsCode(68505803)
end
function c49811191.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
    if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811191.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):Select(tp,1,1,nil)
    Duel.HintSelection(g)
    if Duel.Destroy(g,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end