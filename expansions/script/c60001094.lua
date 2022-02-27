local m = 60001094
local cm = _G["c" .. m]
cm.name = "sH-LIGHT-rForc"

function cm.initial_effect(c)
    c:EnableReviveLimit()

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(cm.splimit)
    c:RegisterEffect(e0)

    --Special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)

    --Pay
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ACTIVATE_COST)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0, 1)
    e2:SetCondition(cm.con2)
    e2:SetTarget(cm.tg2)
    e2:SetCost(cm.cost2)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)

    --Spsummon cost
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_COST)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0, 0x3ff)
    e3:SetCondition(cm.con2)
    e3:SetCost(cm.cost2)
    e3:SetOperation(cm.op2)
    c:RegisterEffect(e3)

    --Battle Target
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE, 0)
    e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e4:SetCondition(cm.con3)
    e4:SetValue(cm.atlimit)
    c:RegisterEffect(e4)
end

function cm.splimit(e, se, sp, st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end

function cm.filter1(c, rp, tp)
    return c:IsPreviousControler(tp) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp == 1 - tp))
end

function cm.con1(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(cm.filter1, 1, nil, rp, tp)
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    c:CompleteProcedure()
end

function cm.con2(e)
    return e:GetHandler():IsAttackPos()
end

function cm.con3(e)
    return e:GetHandler():IsDefensePos()
end

function cm.tg2(e, te, tp)
    return te:IsActiveType(TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP)
end

function cm.cost2(e, te_or_c, tp)
    return Duel.IsPlayerCanDiscardDeckAsCost(tp, 4)
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    Duel.DiscardDeck(tp, 4, REASON_COST)
end

function cm.atlimit(e, c)
    return c:IsFaceup()
end
