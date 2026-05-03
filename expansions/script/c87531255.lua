-- 伏匿之丝 蜘蛛之攫
local COUNTER_EXTEND = 0x19fd

function c87531255.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531255,0))
    e1:SetCategory(CATEGORY_COUNTER+CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c87531255.target)
    e1:SetOperation(c87531255.operation)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetDescription(aux.Stringid(87531255,1))
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCondition(c87531255.actcon)
    e2:SetCost(c87531255.actcost)
    c:RegisterEffect(e2)
end

function c87531255.actcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf8a) end, tp, LOCATION_MZONE, 0, 1, nil)
end

function c87531255.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c87531255.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c87531255.atlimit(e,c)
    return c~=e:GetHandler()
end

function c87531255.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end

    local is_honka = tc:IsSetCard(0xf8a)

    if is_honka then
        -- 放置延势指示物
        if tc:IsCanAddCounter(COUNTER_EXTEND,1) then
            tc:AddCounter(COUNTER_EXTEND,1,REASON_EFFECT)
        end

        local e_atk=Effect.CreateEffect(c)
        e_atk:SetType(EFFECT_TYPE_FIELD)
        e_atk:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
        e_atk:SetRange(LOCATION_MZONE)
        e_atk:SetTargetRange(0,LOCATION_MZONE)
        e_atk:SetCondition(function(e) return e:GetHandler():GetCounter(COUNTER_EXTEND)>0 end)
        e_atk:SetValue(c87531255.atlimit)
        e_atk:SetReset(RESET_EVENT+RESETS_STANDARD)
        e_atk:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
        tc:RegisterEffect(e_atk)

        if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(87531255,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
                local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
                if #g>0 then
                    Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
                end
            end
        end
    else
        Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
        local can_restrict = Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xf8a)
        if can_restrict and Duel.SelectYesNo(tp,aux.Stringid(87531255,3)) then
            -- 不能变更表示形式
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)

            -- 不能解放
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UNRELEASABLE_SUM)
            e2:SetValue(1)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)

            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
            e3:SetValue(1)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e3)

            -- 不能作为融合素材
            local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
            e4:SetValue(1)
            e4:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e4)
        end
    end
end