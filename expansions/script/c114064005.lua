function c114064005.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCode(EFFECT_SEND_REPLACE)
    e1:SetTarget(c114064005.reptg)
    e1:SetValue(c114064005.value)
    e1:SetOperation(c114064005.repop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetOperation(c114064005.thop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_CONTROL)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c114064005.condition2)
    e3:SetTarget(c114064005.target2)
    e3:SetOperation(c114064005.activate2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c114064005.eftg2)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(114064005,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCondition(c114064005.thcon2)
    e5:SetTarget(c114064005.thtg2)
    e5:SetOperation(c114064005.thop2)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetTargetRange(LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0)
    e6:SetTarget(c114064005.eftg2)
    e6:SetLabelObject(e5)
    c:RegisterEffect(e6)
end
function c114064005.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetDestination()==LOCATION_GRAVE and c:IsSetCard(0xa4) and not c:IsCode(114064005) and Duel.GetFlagEffect(tp,114064005)==0
end
function c114064005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(c114064005.repfilter,1,nil,tp) and c:IsAbleToGrave() end
    if Duel.SelectYesNo(tp,aux.Stringid(114064005,0)) then
        local sg=eg:Filter(c114064005.repfilter,nil,tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
        if sg and sg:GetCount()>0 then
            Duel.ConfirmCards(1-tp,sg)
        end
        return true
    end
    return false
end
function c114064005.value(e,c)
    return c114064005.repfilter(c,e:GetHandlerPlayer())
end
function c114064005.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,114064005,RESET_PHASE+PHASE_END,0,1)
    Duel.SendtoGrave(e:GetHandler(),REASON_REPLACE+REASON_EFFECT)
end
function c114064005.actfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCode(80831721,15471265,20065322,25573054,40703222,85787173,89086566)
end
function c114064005.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,114064006)>0 then return end
    Duel.RegisterFlagEffect(tp,114064006,RESET_PHASE+PHASE_END,0,1)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c114064005.actfilter,tp,0xff,0xff,nil)
    for tc in aux.Next(g) do
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_FIELD)
        e0:SetCode(EFFECT_SPSUMMON_PROC_G)
        e0:SetRange(LOCATION_DECK)
        e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
        e0:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e0,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_ACTIVATE_COST)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(1,0)
        e1:SetTarget(c114064005.actarget)
        e1:SetOperation(c114064005.costop)
        Duel.RegisterEffect(e1,tp)
        local ae=tc:GetActivateEffect():Clone()
        local con=ae:GetCondition()
        ae:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
        ae:SetCondition(c114064005.actcon(con))
        ae:SetRange(LOCATION_DECK)
        ae:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(ae,true)
    end
end
function c114064005.actcon(con)
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and c:IsCode(80831721,15471265,20065322,25573054,40703222,85787173,89086566) and ((c:IsType(TYPE_TRAP) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY))) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2))) and c:IsLocation(LOCATION_DECK)
    end
end
function c114064005.actarget(e,te,tp)
    local tc=te:GetHandler()
    e:SetLabelObject(tc)
    return c114064005.actfilter(tc) and tc:IsLocation(LOCATION_DECK)
end
function c114064005.costop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c114064005.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c114064005.aclimit(e,re,tp)
    return re:GetHandler():IsLocation(LOCATION_DECK) and re:GetHandler():IsCode(e:GetHandler():GetCode())
end
function c114064005.condition2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c114064005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local at=Duel.GetAttackTarget()
    if chk==0 then return a and a:IsOnField() and a:IsAbleToChangeControler() and at and at:IsOnField() and at:IsAbleToChangeControler() and c:GetFlagEffect(114064007)==0 end
    c:RegisterFlagEffect(114064007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
    local g=Group.FromCards(a,at)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c114064005.activate2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local at=Duel.GetAttackTarget()
    if a:IsRelateToEffect(e) and a:IsAttackable() and at:IsRelateToEffect(e) then
        if Duel.SwapControl(a,at,RESET_PHASE+PHASE_BATTLE,1) then
            Duel.CalculateDamage(a,at)
        end
    end
end
function c114064005.eftg2(e,c)
    return c:IsSetCard(0xa4) and c:IsType(TYPE_MONSTER)
end
function c114064005.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and not c:IsReason(REASON_LINK)
end
function c114064005.thfilter(c,e,tp,tc)
    return c:IsSetCard(0xa4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode())
end
function c114064005.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114064005.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c) and c:GetFlagEffect(114064005)==0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    c:RegisterFlagEffect(114064005,RESET_CHAIN,0,1)
end
function c114064005.thop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c114064005.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,c)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,g:GetFirst():GetCode()))
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end