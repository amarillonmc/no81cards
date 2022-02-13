--ケルビムの残滓
local m=22520009
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetCondition(cm.atcon)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EQUIP_LIMIT)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.tdcon)
    e3:SetTarget(cm.tdtg)
    e3:SetOperation(cm.tdop)
    c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and not ec:IsSetCard(0xec1)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,22520002) and eg:IsExists(Card.IsFaceup,1,nil) and #eg==1
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local c=e:GetHandler()
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    if tc:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Equip(tp,c,tc)
    end
end
