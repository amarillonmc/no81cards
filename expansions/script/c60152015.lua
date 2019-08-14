--战后的休惬
function c60152015.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152015,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCountLimit(1,60152015+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60152015.condition)
    e1:SetTarget(c60152015.target)
    e1:SetOperation(c60152015.activate)
    c:RegisterEffect(e1)
    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152015,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(c60152015.descost)
    e2:SetTarget(c60152015.destg)
    e2:SetOperation(c60152015.activate2)
    c:RegisterEffect(e2)
end
function c60152015.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c60152015.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0x6b25) or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) 
        and c:GetAttack()~=c:GetBaseAttack()
end
function c60152015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152015.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60152015.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(c60152015.filter,tp,LOCATION_MZONE,0,nil)
    local tc=sg:GetFirst()
    while tc do
        if tc:GetAttack()>tc:GetBaseAttack() then
            local atk=(tc:GetAttack()-tc:GetBaseAttack())
            Duel.Recover(tp,atk/2,REASON_EFFECT)
        elseif tc:GetAttack()<tc:GetBaseAttack() then
            local atk=(tc:GetBaseAttack()-tc:GetAttack())
            Duel.Recover(tp,atk/2,REASON_EFFECT)
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(tc:GetBaseAttack())
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=sg:GetNext()
    end
end
function c60152015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60152015.filter2(c)
    return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60152015.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingMatchingCard(c60152015.filter2,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60152015.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60152015.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
    if g:GetCount()>0 then
        if Duel.SendtoDeck(g,nil,3,REASON_EFFECT)~=0 then
            Duel.BreakEffect()
            Duel.ShuffleDeck(tp)
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end