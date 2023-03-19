--セフェルの多元魔導書
function c115698141.initial_effect(c)
    --copy spell
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,115698141+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c115698141.condition)
    e1:SetCost(c115698141.cost)
    e1:SetTarget(c115698141.target)
    e1:SetOperation(c115698141.operation)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e2)
    --cannot set
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e3)
    --remove type
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_REMOVE_TYPE)
    e4:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e4)
end

function c115698141.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c115698141.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c115698141.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c115698141.cffilter(c)
    return c:IsSetCard(0x306e) and not c:IsPublic()
end
function c115698141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115698141.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c115698141.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c115698141.filter(c)
    return c:IsSetCard(0x306e) and not c:IsCode(115698141) and c:CheckActivateEffect(true,true,false)~=nil
end
function c115698141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        local te=e:GetLabelObject()
        local tg=te:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end
    if chk==0 then return Duel.IsExistingTarget(c115698141.filter,tp,LOCATION_GRAVE,0,1,nil) end
    e:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e:SetCategory(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c115698141.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    local te=g:GetFirst():CheckActivateEffect(true,true,false)
    Duel.ClearTargetCard()
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    e:SetLabel(te:GetLabel())
    e:SetLabelObject(te:GetLabelObject())
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
    te:SetLabel(e:GetLabel())
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
end
function c115698141.rfilter(c)
    return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c115698141.operation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local sel=e:GetLabel()
    if te:GetHandler():IsRelateToEffect(e) then
        e:SetLabel(te:GetLabel())
        e:SetLabelObject(te:GetLabelObject())
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        te:SetLabel(e:GetLabel())
        te:SetLabelObject(e:GetLabelObject())
    end
end
