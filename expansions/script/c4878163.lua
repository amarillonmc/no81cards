local m=4878163
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(1160)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.condition)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCondition(cm.actcon1)
    e3:SetOperation(cm.actop1)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_PZONE)
    e4:SetCode(EVENT_CHAIN_END)
    e4:SetOperation(cm.subop)
    c:RegisterEffect(e4)
end
function cm.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(cm.actlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.actlimit(e,re,rp)
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_SPELL) and rc:IsType(TYPE_RITUAL)
end
function cm.actfilter1(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.actcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.actfilter1,1,nil,tp)
end
function cm.actop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetCurrentChain()==0 then
        Duel.SetChainLimitTillChainEnd(cm.chlimit)
    elseif Duel.GetCurrentChain()==1 then
        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAINING)
        e1:SetOperation(cm.resetop)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EVENT_BREAK_EFFECT)
        e2:SetReset(RESET_CHAIN)
        Duel.RegisterEffect(e2,tp)
    end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:ResetFlagEffect(m)
    e:Reset()
end
function cm.cfilter(c)
    return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.subop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(m)~=0 then
        Duel.SetChainLimitTillChainEnd(cm.chlimit)
    end
end
function cm.chlimit(e,ep,tp)
    return ep==tp or e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end