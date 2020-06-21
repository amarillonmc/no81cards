--Uni☆ties 永恒中心 阿依特
local m=89388024
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcc22),4,2)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.imcon)
    e1:SetValue(cm.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcc22))
    e2:SetValue(cm.atkval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(cm.setcon)
    e3:SetTarget(cm.settg)
    e3:SetOperation(cm.setop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.chcon)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.chtg)
    e4:SetOperation(cm.chop)
    c:RegisterEffect(e4)
end
function cm.imcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.atkval(e,c)
    return e:GetHandler():GetOverlayCount()*300
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.cfilter(c)
    return c:IsSetCard(0xcc22) and not c:IsPublic()
end
function cm.filter(c)
    return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local n=2
    if n>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) then n=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,n,nil)
    Duel.ConfirmCards(1-tp,g1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,g1:GetCount(),g1:GetCount(),nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()==0 then return end
    Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
