--三角獣
function c49811214.initial_effect(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c49811214.splimit)
    c:RegisterEffect(e1)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,49811214)
    e1:SetCondition(c49811214.spcon)
    e1:SetTarget(c49811214.sptg)
    e1:SetOperation(c49811214.spop)
    c:RegisterEffect(e1)
    --gain effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e2:SetCondition(c49811214.efcon)
    e2:SetOperation(c49811214.efop)
    c:RegisterEffect(e2)
end
function c49811214.splimit(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c49811214.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c49811214.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811214.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c49811214.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811214.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        if c:IsSummonLocation(LOCATION_GRAVE) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetValue(LOCATION_REMOVED)
            e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
            c:RegisterEffect(e1,true)
        end
        local g=Duel.GetMatchingGroup(c49811214.cfilter,tp,LOCATION_REMOVED,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(49811214,0)) then
                Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local tag=g:Select(tp,1,1,nil)
            Duel.SendtoHand(tag,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tag)
        end
    end
end
function c49811214.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsRace(RACE_BEAST)
end
function c49811214.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(49811214,1))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(2,49811214)
    e1:SetCondition(c49811214.chcon)
    e1:SetTarget(c49811214.chtg)
    e1:SetOperation(c49811214.chop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
    rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811214,2))
end
function c49811214.chcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and re:GetActivateLocation()==LOCATION_GRAVE
end
function c49811214.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,rp,0,LOCATION_EXTRA,1,nil,e) end
end
function c49811214.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c49811214.repop)
end
function c49811214.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDestructable,1-tp,LOCATION_EXTRA,0,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
    local sg=g:Select(1-tp,1,1,nil)
    if sg:GetCount()>0 then
        Duel.Destroy(sg,REASON_EFFECT)
    end
end