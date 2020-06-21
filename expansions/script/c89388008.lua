--彗星防护壁
local m=89388008
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1,m)
    e4:SetCost(cm.descost)
    e4:SetTarget(cm.destg)
    e4:SetOperation(cm.desop)
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if Duel.GetFieldGroup(tp,LOCATION_MZONE,0):GetCount()==0 then
        e:SetLabel(100)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
    end
end
function cm.filter(c,e,sp)
    return c:IsSetCard(0xcc20) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or e:GetLabel()~=100 then return end
    local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
    if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=cg:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function cm.costfilter(c)
    return c:IsSetCard(0xcc20) and c:IsAbleToRemoveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function cm.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0xcc20) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desfilter(c)
    return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xcc20) and c:IsAbleToDeck()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=eg:Filter(cm.repfilter,nil)
    if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
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
