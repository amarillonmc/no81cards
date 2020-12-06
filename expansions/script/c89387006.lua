--希望皇 拟声拼图
local m=89387006
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x54,0x59,0x82,0x8f),2,2)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(84013237)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(cm.efcon)
    e3:SetOperation(cm.efop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_MATERIAL)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.efcon2)
    e4:SetOperation(cm.efop2)
    c:RegisterEffect(e4)
end
function cm.descfilter(c,lg)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x107f) and lg:IsContains(c)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(cm.descfilter,1,nil,lg)
end
function cm.thfilter(c)
    return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0x48)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e2=Effect.CreateEffect(rc)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(cm.indval)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e2,true)
    local e1=e2:Clone()
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
    rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.indval(e,c)
    return not c:IsSetCard(0x48)
end
function cm.effilter(c,tp,zone)
    local seq=c:GetPreviousSequence()
    if c:GetPreviousControler()~=tp then seq=seq+16 end
    return c:GetReasonCard():IsSetCard(0x48) and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function cm.efcon2(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and eg:IsExists(cm.effilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function cm.efop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local sg=eg:Filter(cm.effilter,nil,tp,e:GetHandler():GetLinkedZone())
    for c in aux.Next(sg) do
        local rc=c:GetReasonCard()
        local e2=Effect.CreateEffect(rc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetValue(cm.indval)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
        local e1=e2:Clone()
        e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        rc:RegisterEffect(e1,true)
        if not rc:IsType(TYPE_EFFECT) then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_ADD_TYPE)
            e2:SetValue(TYPE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            rc:RegisterEffect(e2,true)
        end
        rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
    end
end
