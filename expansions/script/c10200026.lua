function c10200026.initial_effect(c)
    c:EnableCounterPermit(0xe23)
    -- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 骰子效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200026,1))
    e1:SetCategory(CATEGORY_DICE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c10200026.tg1)
    e1:SetOperation(c10200026.op1)
    c:RegisterEffect(e1)
    -- 五-指-拳-心-剑!
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200026,2))
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(5,10200026)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(c10200026.cost2)
    e2:SetTarget(c10200026.tg2)
    e2:SetOperation(c10200026.op2)
    c:RegisterEffect(e2)
end
-- 1
function c10200026.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200026.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsLocation(LOCATION_SZONE) then return end
    Duel.TossDice(tp,1)
    local dice=Duel.GetDiceResult()
    c:AddCounter(0xe23,dice)
end
-- 2
function c10200026.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0xe23)>=1 end
    Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0xe23,1,REASON_COST)
end
function c10200026.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200026.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,500,REASON_EFFECT)
    local ct=Duel.GetFlagEffect(tp,10200026)
    ct=ct+1
    Duel.RegisterFlagEffect(tp,10200026,RESET_PHASE+PHASE_END,0,1,ct)
    if Duel.SelectYesNo(tp, aux.Stringid(10200026,3)) then
        if ct >= 1 then
            local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
            for tc in aux.Next(g1) do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(-300)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
        if ct >= 2 then
            Duel.Damage(1-tp,500,REASON_EFFECT)
        end
        if ct >= 3 then
            local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
            for tc in aux.Next(g2) do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(300)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
        if ct >= 4 then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
        if ct >= 5 then
            local g3=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
            if g3:GetCount()>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local sg=g3:Select(tp,1,1,nil)
                Duel.Destroy(sg,REASON_EFFECT)
            end
        end
    end
end