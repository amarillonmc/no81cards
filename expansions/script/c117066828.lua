--星光天使ソオド
function c117066828.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c117066828.spcon)
    c:RegisterEffect(e1)
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,117066828)
    e2:SetCost(c117066828.copycost)
    e2:SetTarget(c117066828.copytg)
    e2:SetOperation(c117066828.copyop)
    c:RegisterEffect(e2)
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(c117066828.effcon)
    e3:SetOperation(c117066828.effop)
    c:RegisterEffect(e3)
end
function c117066828.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x86)
end
function c117066828.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c117066828.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c117066828.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c117066828.copyfilter(c,code)
    return c:IsSetCard(0x86) and c:IsType(TYPE_EFFECT) and c:GetBaseAttack()>0 and c:GetCode()~=code and c:IsAbleToGraveAsCost()
end
function c117066828.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c117066828.copyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c117066828.copyfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c:GetCode())
    local tc=g:GetFirst()
    Duel.SendtoGrave(tc,REASON_COST)
    Duel.SetTargetCard(tc)
end
function c117066828.copyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tc:GetAttack())
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
    end
end

function c117066828.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():GetMaterial():IsExists(Card.IsPreviousLocation,3,nil,LOCATION_MZONE)
end
function c117066828.effop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,117066828)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(117066828,1))
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetDescription(aux.Stringid(117066828,2))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c117066828.xyzcost)
    e1:SetTarget(c117066828.xyztg)
    e1:SetOperation(c117066828.xyzop)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(rc)
    e2:SetDescription(aux.Stringid(117066828,3))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c117066828.atkcon)
    e2:SetCost(c117066828.atkcost)
    e2:SetOperation(c117066828.atkop)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e2,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e2,true)
    end
end

function c117066828.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c117066828.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c117066828.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end

function c117066828.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c117066828.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c117066828.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
