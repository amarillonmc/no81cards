--根源の始 两仪式
function c60151204.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e99=Effect.CreateEffect(c)
    e99:SetType(EFFECT_TYPE_SINGLE)
    e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e99:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e99)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLE_CONFIRM)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60151204.condition2)
    e1:SetOperation(c60151204.desop)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,60151204)
    e2:SetCondition(c60151204.thcon)
    e2:SetCost(c60151204.thcost)
    e2:SetTarget(c60151204.thtg)
    e2:SetOperation(c60151204.thop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151204,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,6011204)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1e0)
    e3:SetTarget(c60151204.tg)
    e3:SetOperation(c60151204.op)
    c:RegisterEffect(e3)
end
function c60151204.condition2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsFaceup()
end
function c60151204.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if c:GetBattleTarget()==nil then return end
    if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
        local atk=c:GetAttack()
        local atk1=tc:GetAttack()
        local def1=tc:GetDefense()
        if c:GetFlagEffect(60151298)>0 then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
            Duel.Hint(HINT_CARD,0,60151204)
            if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
                local atk2=tc:GetBaseAttack()
                if atk>atk2 then Duel.BreakEffect()
                    Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
                end
                if atk2>atk then Duel.BreakEffect()
                    Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
                end
            end
        else
            if atk>atk1 or atk>def1 then
                Duel.SelectOption(tp,aux.Stringid(60151201,1))
                Duel.Hint(HINT_CARD,0,60151204)
                if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
                    local atk2=tc:GetBaseAttack()
                    if atk>atk2 then Duel.BreakEffect()
                        Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
                    end
                    if atk2>atk then Duel.BreakEffect()
                        Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
                    end
                end
            end
        end
    end
end
function c60151204.cfilter(c)
    return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
function c60151204.thcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60151204.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151204.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60151204.thfilter(c)
    return c:IsCode(60151299) and c:IsAbleToHand()
end
function c60151204.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151204.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151204.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151204.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60151204.filter(c)
    return c:IsAbleToGrave()
end
function c60151204.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if e:GetHandler():GetFlagEffect(60151298)>0 then
        if chk==0 then return true end
    else
        if chk==0 then return Duel.IsExistingMatchingCard(c60151204.filter,tp,0,LOCATION_ONFIELD,1,nil) end
        local g=Duel.GetMatchingGroup(c60151204.filter,tp,0,LOCATION_ONFIELD,nil)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
    end
end
function c60151204.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151204.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        if e:GetHandler():GetFlagEffect(60151298)>0 then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
            Duel.Hint(HINT_CARD,0,60151204)
            Duel.SendtoGrave(g,REASON_RULE)
        else
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end