--コキュートスの決戦
local m=22520012
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCondition(cm.condition2)
    e4:SetTarget(cm.target2)
    e4:SetOperation(cm.activate2)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.acttg)
    e1:SetOperation(cm.actop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCondition(cm.condition)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.setcon)
    e3:SetTarget(cm.settg)
    e3:SetOperation(cm.setop)
    c:RegisterEffect(e3)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0xec1)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,2,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,2,2,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
        if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,22520013) then
            Duel.BreakEffect()
            c:CancelToGrave()
            Duel.ChangePosition(c,POS_FACEDOWN)
            Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        end
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.actfilter(c,tp)
    return c:IsCode(22520011) and c:GetActivateEffect():IsActivatable(tp,false,false)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local te=tc:GetActivateEffect()
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local tep=tc:GetControler()
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
        if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,22520013) then
            Duel.BreakEffect()
            c:CancelToGrave()
            Duel.ChangePosition(c,POS_FACEDOWN)
            Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        end
    end
end
function cm.filter(c)
    return c:IsFaceup() and (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR)) and c:IsDefenseAbove(0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        local atk=tc:GetBaseAttack()+tc:GetBaseDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,22520013) then
            Duel.BreakEffect()
            c:CancelToGrave()
            Duel.ChangePosition(c,POS_FACEDOWN)
            Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        end
    end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsCode,1,nil,tp,22520013)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SSet(tp,c)
    end
end
