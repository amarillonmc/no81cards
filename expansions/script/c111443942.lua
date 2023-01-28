--影依回转
local m=111443942
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.condition)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.actfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9d) and not c:IsCode(m)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
    return g:IsExists(cm.actfilter,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(cm.actfilter,tp,0xff,0,nil)
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
        e1:SetCost(cm.costchk)
        e1:SetTargetRange(1,0)
        e1:SetTarget(cm.actarget)
        e1:SetOperation(cm.costop)
        Duel.RegisterEffect(e1,tp)
        local ae=tc:GetActivateEffect():Clone()
        local con=ae:GetCondition()
        ae:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
        ae:SetCondition(cm.actcon(con))
        ae:SetRange(LOCATION_DECK)
        ae:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(ae,true)
    end
end
function cm.actcon(con)
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and c:IsSetCard(0x9d) and ((c:IsType(TYPE_TRAP) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY))) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2))) and c:IsLocation(LOCATION_DECK)
    end
end
function cm.cfilter(c)
    return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.costchk(e,te_or_c,tp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.actarget(e,te,tp)
    local tc=te:GetHandler()
    e:SetLabelObject(tc)
    return cm.actfilter(tc) and tc:IsLocation(LOCATION_DECK)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if Duel.GetFlagEffect(tp,tc:GetCode()+1)>0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    Duel.RegisterFlagEffect(tp,tc:GetCode()+1,RESET_PHASE+PHASE_END,0,1)
    local e1=Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(cm.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
    return re:GetHandler():IsLocation(LOCATION_DECK) and re:GetHandler():IsCode(e:GetHandler():GetCode())
end
