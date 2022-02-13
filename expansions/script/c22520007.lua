--罰の執行－グラッフィアカーネ
local m=22520007
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.actcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.descon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.destarget)
    e2:SetOperation(cm.desactivate)
    c:RegisterEffect(e2)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_FIEND)
end
function cm.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToGrave()
end
function cm.dmfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xec1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
    local ct=Duel.GetMatchingGroupCount(cm.dmfilter,tp,LOCATION_GRAVE,0,nil)
    if ct>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
        and Duel.IsExistingMatchingCard(cm.dmfilter,tp,LOCATION_GRAVE,0,1,nil) then
        Duel.BreakEffect()
        local ct=Duel.GetMatchingGroupCount(cm.dmfilter,tp,LOCATION_GRAVE,0,nil)
        Duel.Damage(1-tp,ct*800,REASON_EFFECT)
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_BEASTWARRIOR)
end
function cm.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desactivate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
