--处刑人的万华镜
local m=121593977
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_PREDRAW)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    e0:SetRange(LOCATION_HAND+LOCATION_DECK)
    e0:SetOperation(cm.op)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    e2:SetCode(EFFECT_SKIP_DP)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsType,TYPE_COUNTER)))
    e3:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(cm.desreptg)
    e4:SetOperation(cm.desrepop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,3))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_SZONE)
    e5:SetOperation(cm.mtop)
    c:RegisterEffect(e5)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_CANNOT_SSET)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e8)
end
function cm.spfilter(c)
    return c:IsType(TYPE_TRAP) and not c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,c)
    if g:GetCount()==0 then return end
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
    Duel.SetLP(tp,4000)
end
function cm.filter(c,tp)
    return c:GetType()==TYPE_TRAP and not c:IsPublic() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
    return c:IsCode(code) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    if chk==0 then return true end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    e:SetLabel(0,g:GetFirst():GetCode())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local label,code=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.repfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function cm.repfilter2(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and (Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(cm.repfilter2,tp,LOCATION_GRAVE,0,2,nil)) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local b1=Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_HAND,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(cm.repfilter2,tp,LOCATION_GRAVE,0,2,nil)
    if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_HAND,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE+REASON_DISCARD)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,cm.repfilter2,tp,LOCATION_GRAVE,0,2,2,nil)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
    end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.HintSelection(Group.FromCards(c))
    local g=Duel.GetMatchingGroup(cm.repfilter2,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,3,3,nil)
        Duel.Remove(sg,POS_FACEUP,REASON_COST)
    else
        Duel.Damage(tp,4000,REASON_COST)
        Duel.SendtoGrave(c,REASON_COST)
    end
end