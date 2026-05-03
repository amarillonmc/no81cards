-- 伏匿之丝 希洛布突袭
local COUNTER_TRAMPLE = 0x17cd

function c87531250.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531250,0))
    e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DISABLE+CATEGORY_LEAVE_GRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c87531250.target)
    e1:SetOperation(c87531250.operation)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetDescription(aux.Stringid(87531250,1))
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCondition(c87531250.actcon)
    e2:SetCost(c87531250.actcost)
    c:RegisterEffect(e2)

    local e_trample=Effect.CreateEffect(c)
    e_trample:SetType(EFFECT_TYPE_FIELD)
    e_trample:SetCode(EFFECT_PIERCE)
    e_trample:SetTargetRange(LOCATION_MZONE,0)
    e_trample:SetTarget(c87531250.trample_target)
    e_trample:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_trample,0)
end

function c87531250.actcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf8a) end, tp, LOCATION_MZONE, 0, 1, nil)
end

function c87531250.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c87531250.target_filter(c)
    if c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xf8a) then
        return false
    end
    return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
end

function c87531250.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return c87531250.target_filter(chkc)
    end
    if chk==0 then
        return Duel.IsExistingTarget(c87531250.target_filter, tp, LOCATION_MZONE+LOCATION_GRAVE, LOCATION_MZONE+LOCATION_GRAVE, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, c87531250.target_filter, tp, LOCATION_MZONE+LOCATION_GRAVE, LOCATION_MZONE+LOCATION_GRAVE, 1, 1, nil)
end

function c87531250.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end

    local is_onfield = tc:IsLocation(LOCATION_MZONE)
    local is_honka = tc:IsSetCard(0xf8a)

    if is_honka and is_onfield then
        -- 放置践踏指示物
        if tc:IsCanAddCounter(COUNTER_TRAMPLE,1) then
            tc:AddCounter(COUNTER_TRAMPLE,1,REASON_EFFECT)
            if tc:GetFlagEffect(87531250+1000)==0 then
                tc:RegisterFlagEffect(87531250+1000, RESET_EVENT+RESETS_STANDARD, 0, 1)
                local e_pierce=Effect.CreateEffect(c)
                e_pierce:SetType(EFFECT_TYPE_SINGLE)
                e_pierce:SetCode(EFFECT_PIERCE)
                e_pierce:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e_pierce:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e_pierce, true)
            end
        end

        if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(87531250,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
                local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
                if #g>0 then
                    local opptc=g:GetFirst()
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_DISABLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    opptc:RegisterEffect(e1)
                    local e2=e1:Clone()
                    e2:SetCode(EFFECT_DISABLE_EFFECT)
                    opptc:RegisterEffect(e2)
                    if opptc:IsType(TYPE_TRAPMONSTER) then
                        local e3=Effect.CreateEffect(c)
                        e3:SetType(EFFECT_TYPE_SINGLE)
                        e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                        opptc:RegisterEffect(e3)
                    end
                end
            end
        end
    else
        if is_onfield then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            tc:RegisterEffect(e2)
            if tc:IsType(TYPE_TRAPMONSTER) then
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)
                e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e3)
            end

            local can_place = Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xf8a)
            if can_place then
                if Duel.SelectYesNo(tp,aux.Stringid(87531250,3)) then
                    c87531250.move_to_szone(tc,tp,e)
                end
            end
        else
            c87531250.move_to_szone(tc,tp,e)
        end
    end
end

function c87531250.move_to_szone(tc,tp,eff)
    if not tc:IsRelateToEffect(eff) then return end
    local owner=tc:GetOwner()
    local ft=Duel.GetLocationCount(owner,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)
    if ft<=0 then return end
    if Duel.MoveToField(tc,tp,owner,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(eff:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
    end
end

function c87531250.trample_target(e, c)
    return c:GetCounter(COUNTER_TRAMPLE) > 0
end