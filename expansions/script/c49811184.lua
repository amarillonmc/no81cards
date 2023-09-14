--A・O・J スター·クラッチャー
function c49811184.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --actlimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,1)
    e1:SetValue(c49811184.actlimit)
    c:RegisterEffect(e1)
    --atk down
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c49811184.val)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetDescription(aux.Stringid(49811184,2))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_MSET+TIMING_SSET+TIMING_END_PHASE)
    e3:SetCountLimit(1,49811184)
    e3:SetTarget(c49811184.destg)
    e3:SetOperation(c49811184.desop)
    c:RegisterEffect(e3)
end
function c49811184.actlimit(e,re,tp)
    local loc=re:GetActivateLocation()
    return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetDefense()>e:GetHandler():GetDefense() and re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c49811184.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),0,LOCATION_GRAVE,nil,ATTRIBUTE_LIGHT)*(-300)
end
function c49811184.desfilter(c)
    return c:IsFacedown()
end
function c49811184.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c49811184.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811184.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c49811184.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c49811184.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end