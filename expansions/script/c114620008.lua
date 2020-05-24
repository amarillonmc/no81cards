--世纪末-三叉龙
local m=114620008
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.negcon)
    e2:SetCost(cm.negcost)
    e2:SetTarget(cm.negtg)
    e2:SetOperation(cm.negop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,m+1000)
    e3:SetCondition(cm.remcon)
    e3:SetTarget(cm.remtg)
    e3:SetOperation(cm.remop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_ADJUST)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetOperation(cm.op)
    c:RegisterEffect(e4)
    cm[e4]={}
end
function cm.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xe6f) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoGrave(eg,REASON_EFFECT)
    end
end
function cm.remcon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsSetCard(0xe6f)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:RandomSelect(tp,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.HintSelection(sg1)
        Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.copyfilter(c)
    return not (c:GetOriginalCode()==m) and c:IsFaceup() and c:IsSetCard(0xe6f) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER)
end
function cm.gfilter(c,g)
    if not g then return true end
    return not g:IsContains(c)
end
function cm.gfilter1(c,g)
    if not g then return true end
    return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
    return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local copyt=cm[e]
    local exg=Group.CreateGroup()
    for tc,cid in pairs(copyt) do
        if tc and cid then exg:AddCard(tc) end
    end
    local g=Duel.GetMatchingGroup(cm.copyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local dg=exg:Filter(cm.gfilter,nil,g)
    for tc in aux.Next(dg) do
        c:ResetEffect(copyt[tc],RESET_COPY)
        exg:RemoveCard(tc)
        copyt[tc]=nil
    end
    local cg=g:Filter(cm.gfilter1,nil,exg)
    for tc in aux.Next(cg) do
        copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
    end
end
