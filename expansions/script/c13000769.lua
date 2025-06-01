--大萧条
local cm, m, o = GetID()
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(cm.condition)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)

    local e3 = Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_ADD_SETCODE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE, 0)
    e3:SetValue(0xe09)
    e3:SetTarget(cm.eftg)
    c:RegisterEffect(e3)

    local e22 = Effect.CreateEffect(c)
    e22:SetCategory(CATEGORY_ATKCHANGE)
    e22:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e22:SetCode(EVENT_BATTLE_DESTROYING)
    e22:SetCondition(cm.condition2)
    e22:SetOperation(cm.atkop)
    local e33 = Effect.CreateEffect(c)
    e33:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_GRANT)
    e33:SetRange(LOCATION_SZONE)
    e33:SetTargetRange(LOCATION_MZONE, 0)
    e33:SetTarget(cm.eftg)
    e33:SetLabelObject(e22)
    c:RegisterEffect(e33)
end

function cm.cfilter(c, e)
    return (c:IsSetCard(0xe09) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsDestructable(e)
end

function cm.cfilter2(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeckAsCost()
end

function cm.cfilter3(c)
    return not c:IsCode(m)
end

function cm.condition(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local a = c:GetCode()
    local g = Duel.GetMatchingGroup(cm.cfilter, tp, LOCATION_HAND + LOCATION_ONFIELD, 0, nil, e)
    local g2 = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
    local g3 = g2:__sub(g)
    return (#g2 >= 2 or #g3 >= 1) and
        --Duel.GetMatchingGroupCount(cm.cfilter2, tp, LOCATION_HAND, 0, nil) >= 1 and
        Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
        and Duel.GetTurnPlayer() == tp and
        (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local ta = Duel.SelectMatchingCard(tp, cm.cfilter, tp, LOCATION_HAND + LOCATION_ONFIELD, 0, 1, 1, nil, e)
    Duel.Destroy(ta, REASON_RULE + REASON_COST)
    -- local tc = g3:Select(tp, 1, 1, nil):GetFirst()
    local tc = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_ONFIELD, 0, 1, 1, nil):GetFirst()
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or tc:IsFacedown() then
        Duel.SendtoGrave(c, REASON_EFFECT)
    else
        Duel.Equip(tp, c, tc)
        --Add Equip limit
        local e1 = Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        e1:SetValue(cm.eqlimit)
        c:RegisterEffect(e1)
    end
end

function cm.eqlimit(e, c)
    return e:GetOwner() == c
end

function cm.eftg(e, c)
    return c == e:GetHandler():GetEquipTarget()
end

function cm.condition2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local bc = c:GetBattleTarget()
    e:SetLabel(bc:GetAttack())
    return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end

function cm.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local num = e:GetLabel()
    if not c:IsRelateToEffect(e) then return end
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(num)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
    c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(1)
    e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
    c:RegisterEffect(e3)

    local e12 = Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CHANGE_DAMAGE)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetTargetRange(1, 0)
    e12:SetValue(0)
    e12:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e12, 1 - tp)
    local e22 = e1:Clone()
    e22:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e22:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e22, 1 - tp)

    local e32 = Effect.CreateEffect(c)
    e32:SetType(EFFECT_TYPE_FIELD)
    e32:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e32:SetTargetRange(LOCATION_ONFIELD, 0)
    e32:SetTarget(aux.TRUE)
    e32:SetValue(1)
    e32:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e32, tp)
    local e33 = e32:Clone()
    e33:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    Duel.RegisterEffect(e33, tp)

    local e222 = Effect.CreateEffect(c)
    e222:SetReset(RESET_EVENT + RESET_PHASE + PHASE_END, 2)
    e222:SetLabel(0)
    Duel.RegisterEffect(e222, tp)

    local e2222 = Effect.CreateEffect(c)
    e2222:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2222:SetCode(EVENT_LEAVE_FIELD)
    e2222:SetReset(RESET_EVENT + RESET_PHASE + PHASE_END)
    e2222:SetCountLimit(1)
    e2222:SetLabelObject(e222)
    e2222:SetOperation(cm.atkop3)
    Duel.RegisterEffect(e2222, tp)

    local e31 = Effect.CreateEffect(c)
    e31:SetCategory(CATEGORY_ATKCHANGE)
    e31:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e31:SetCode(EVENT_PHASE_START + PHASE_END)
    e31:SetReset(RESET_EVENT + RESET_PHASE + PHASE_END, 2)
    e31:SetCountLimit(1)
    e31:SetLabelObject(e222)
    e31:SetLabel(Duel.GetTurnCount())
    e31:SetCondition(cm.spcon)
    e31:SetOperation(cm.atkop2)
    Duel.RegisterEffect(e31, tp)
end

function cm.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnCount() ~= e:GetLabel()
end

function cm.atkop2(e, tp, eg, ep, ev, re, r, rp)
    local num = e:GetLabelObject():GetLabel()
    if num < 0 then
        num = 0
    end
    Duel.SetLP(1 - tp, Duel.GetLP(1 - tp) - num)
end

function cm.atkop4(c, tp, g)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end

function cm.atkop3(e, tp, eg, ep, ev, re, r, rp)
    local num = e:GetLabelObject():GetLabel()
    local num2 = eg:Filter(cm.atkop4, nil, 1 - tp, eg)
    if #num2 > 0 then
        num2 = num + #num2 * 500
        e:GetLabelObject():SetLabel(num2)
    end
end
