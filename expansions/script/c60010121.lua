--月诫
local cm,m,o=GetID()
function cm.initial_effect(c)
    --cannot set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetTargetRange(1,0)
    e2:SetLabelObject(c)
    e2:SetTarget(cm.tg)
    c:RegisterEffect(e2)
    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetTargetRange(1,0)
    e3:SetLabelObject(c)
    e3:SetTarget(cm.tg)
    c:RegisterEffect(e3)

    --activated
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end
function cm.tg(e,c)
    return c==e:GetLabelObject()
end
function cm.rmfil(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,800,REASON_EFFECT)
    Duel.SortDecktop(tp,tp,3)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetCondition(cm.spcon)
    e1:SetOperation(cm.spop)
    if Duel.GetCurrentPhase()<=PHASE_STANDBY then
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_STANDBY)
    end
    Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter(c)
    return c:IsCode(m) and c:IsAbleToRemove()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()~=e:GetLabel() 
        and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end