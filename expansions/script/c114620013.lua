--世纪末
local m=114620013
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(cm.condition)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,1)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetValue(m)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.skcon)
    e3:SetOperation(cm.skop)
    c:RegisterEffect(e3)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
    c:RegisterEffect(e0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetCurrentChain()~=0 then return false end
    if Duel.GetTurnPlayer()==tp then
        if c:IsHasEffect(114620005) then return true end
        return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
    else
        if c:IsHasEffect(114620005) then return c:IsLocation(LOCATION_HAND) end
        return false
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)~=0 then return false end
    local c=e:GetHandler()
    if Duel.GetCurrentChain()~=0 then return false end
    if Duel.GetTurnPlayer()==tp then
        if c:IsHasEffect(114620005) then return true end
        return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
    else
        if c:IsHasEffect(114620005) then return c:IsLocation(LOCATION_HAND) end
        return false
    end
end
function cm.skcon(e,tp,eg,ep,ev,re,r,rp,chk)
    return tp==Duel.GetTurnPlayer()
end
function cm.skop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsCanTurnSet() and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_CARD,0,m)
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetTargetRange(0,1)
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
