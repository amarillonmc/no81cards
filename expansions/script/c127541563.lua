function c127541563.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(127541563,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c127541563.discon)
    e2:SetCost(c127541563.discost)
    e2:SetTarget(c127541563.distg)
    e2:SetOperation(c127541563.disop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetDescription(aux.Stringid(127541563,1))
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c127541563.descon2)
    e4:SetOperation(c127541563.desop2)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCondition(c127541563.descon)
    e5:SetTarget(c127541563.destg)
    e5:SetOperation(c127541563.desop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e6:SetCondition(c127541563.handcon)
    c:RegisterEffect(e6)
end
function c127541563.discon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp~=tp
end
function c127541563.cfilter(c)
    return c:IsSetCard(0x103) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c127541563.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c127541563.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c127541563.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function c127541563.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsCanTurnSet() and not re:GetHandler():IsType(TYPE_PENDULUM) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
    end
end
function c127541563.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
        rc:CancelToGrave()
        Duel.ChangePosition(eg,POS_FACEDOWN_DEFENSE)
        local tc=eg:GetFirst()
        tc:CancelToGrave()
        c:SetCardTarget(tc)
        e:SetLabelObject(tc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_LEAVE)
        e1:SetCondition(c127541563.rcon)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        tc:RegisterEffect(e2)
        c:RegisterFlagEffect(127541563,RESET_LEAVE,0,1,c:GetFieldID(),nil)
        tc:RegisterFlagEffect(127541563,RESET_LEAVE,0,1,c:GetFieldID(),nil)
    end
end
function c127541563.rcon(e)
    return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c127541563.gfilter(c,g)
    return g:IsContains(c)
end
function c127541563.descon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c127541563.gfilter,1,nil,e:GetHandler():GetCardTarget())
end
function c127541563.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c127541563.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c127541563.tgfilter(c,id)
    return c:GetFlagEffectLabel(127541563) and c:GetFlagEffectLabel(127541563)==id
end
function c127541563.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c127541563.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler():GetFlagEffectLabel(127541563))
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c127541563.spfilter(c,e,tp)
    return c:IsSetCard(0x103) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c127541563.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c127541563.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c:GetFlagEffectLabel(127541563))
    if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c127541563.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(127541563,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=Duel.SelectMatchingCard(tp,c127541563.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if not tg then return end
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c127541563.hfilter(c)
    return c:IsFacedown() or not c:IsSetCard(0x103)
end
function c127541563.handcon(e)
    return not Duel.IsExistingMatchingCard(c127541563.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end