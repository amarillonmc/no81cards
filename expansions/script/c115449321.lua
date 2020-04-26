--星灵兽辉 太阳神威
local m=115449321
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetRange(LOCATION_DECK)
    e2:SetCondition(cm.con2)
    e2:SetCost(cm.cost2)
    e2:SetTarget(cm.target2)
    e2:SetOperation(cm.operation2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,m)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetTarget(cm.sptarget)
    e4:SetOperation(cm.spoperation)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTarget(cm.desreptg)
    e5:SetValue(cm.desrepval)
    e5:SetOperation(cm.desrepop)
    c:RegisterEffect(e5)
end
function cm.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xb5)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.confilter,1,nil) and e:GetHandler():CheckUniqueOnField(tp)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then return end
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.rmfilter(c)
    return c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tgfilter(c)
    return c:IsSetCard(0xb5) and c:IsSummonable(true,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
end
function cm.filter(c)
    return c:IsSetCard(0xb5) and c:IsAbleToRemove()
end
function cm.filter2(c,e,tp)
    return cm.filter(c) and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function cm.filter3(c,e,tp,tc)
    return cm.filter(c) and Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(tc,c))
end
function cm.filter4(c,e,tp,g)
    return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function cm.spoperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc1=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc2=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_MZONE,0,1,1,tc1,e,tp,tc1):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.filter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,Group.FromCards(tc1,tc2))
        if g:GetCount()>0 then
            Duel.Remove(Group.FromCards(tc1,tc2),POS_FACEUP,REASON_EFFECT)
            Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end
function cm.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb5) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desfilter(c)
    return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xb5) and c:IsAbleToDeck()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=eg:Filter(cm.repfilter,nil)
    if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_REMOVED,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_REMOVED,0,1,g:GetCount(),nil)
        e:SetLabelObject(sg)
        return true
    else return false end
end
function cm.desrepval(e,c)
    return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local tg=e:GetLabelObject()
    Duel.SendtoDeck(tg,nil,2,REASON_EFFECT+REASON_REPLACE)
end