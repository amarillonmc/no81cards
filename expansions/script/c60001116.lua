local m = 60001116
local cm = _G["c" .. m]
cm.name = "圣兽装骑·鲨"

function cm.initial_effect(c)
    --Special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, m)
    e2:SetTarget(cm.tg2)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)

    --Special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, m + 1)
    e1:SetTarget(cm.tg3)
    e1:SetOperation(cm.op3)
    c:RegisterEffect(e1)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x562e) and c:IsType(TYPE_MONSTER)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_MZONE, 0, 1, nil)
    end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_MZONE, 0, 1, nil)
            and not Duel.IsPlayerAffectedByEffect(tp, m)
    end
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(m)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_CANNOT_DISABLE)
    e3:SetTargetRange(1, 0)
    Duel.RegisterEffect(e3, tp)
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e2:SetTargetRange(1, 0)
    e2:SetTarget(cm.splimit)
    e2:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e2, tp)
end

function cm.splimit(e, c)
    return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.filter3(c, e, tp)
    return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(cm.filter3, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, cm.filter3, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
end
