--最後の黙示録
local m=22520011
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
    return c:IsSetCard(0xec1) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local n=eg:FilterCount(cm.cfilter,nil,tp)
    local g=Duel.GetDecktopGroup(tp,n)
    if g:FilterCount(Card.IsAbleToRemove,nil)>=n and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22520013,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then
        Duel.Hint(HINT_CARD,PLAYER_ALL,m)
        if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)<=0 then return end
        for i=1,n do
            local token=Duel.CreateToken(tp,22520013)
            Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_FIELD)
            e3:SetRange(LOCATION_MZONE)
            e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e3:SetTargetRange(1,0)
            e3:SetTarget(cm.sumlimit)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            token:RegisterEffect(e3,true)
        end
        Duel.SpecialSummonComplete()
    end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA)
end
function cm.tgfilter(c)
    return c:IsFacedown() and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
    return c:IsCode(22520006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,13,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,13,13,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not c:IsRelateToEffect(e) or not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<13 then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
    if ct==13 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if sg:GetCount()>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
