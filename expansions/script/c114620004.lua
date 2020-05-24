--世纪末-幽风女食人魔
local m=114620004
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.spcon)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(cm.condition)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,3))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCondition(cm.condition)
    e3:SetTarget(cm.target2)
    e3:SetOperation(cm.operation2)
    c:RegisterEffect(e3)
end
function cm.spfilter(c,tp)
    return c:IsSetCard(0xe6f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,tp)
    return g:CheckWithSumEqual(Card.GetLevel,6,1,99)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(cm.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,c,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,99)
    Duel.SendtoGrave(sg,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsSetCard(0xe6f)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and c:GetFlagEffect(m)==0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    if ct==0 then return end
    local ac=1
    if ct>1 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
        ac=Duel.AnnounceNumber(tp,1,2)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,1,1,nil)
    Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    Duel.ShuffleHand(1-tp)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and c:GetFlagEffect(m)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
