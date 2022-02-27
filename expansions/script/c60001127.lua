local m = 60001127
local cm = _G["c" .. m]
cm.name = "圣兽装骑·骸"

function cm.initial_effect(c)
    --Special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1, m)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, m)
    e2:SetTarget(cm.tg2)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)

    --damage
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCondition(cm.con3)
    e3:SetTarget(cm.tg3)
    e3:SetOperation(cm.op3)
    c:RegisterEffect(e3)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_MZONE, 1, nil)
    end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = Duel.SelectMatchingCard(tp, Card.Type, tp, 0, LOCATION_MZONE, 1, 1, nil, e, tp, TYPE_MONSTER)
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    local tc = g:GetFirst()
    Duel.CalculateDamage(c, tc)
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_MZONE, 1, nil)
            and not Duel.IsPlayerAffectedByEffect(tp, m)
    end
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(m)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_CANNOT_DISABLE)
    e2:SetTargetRange(1, 0)
    Duel.RegisterEffect(e2, tp)
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = Duel.SelectMatchingCard(tp, Card.Type, tp, 0, LOCATION_MZONE, 1, 1, nil, e, tp, TYPE_MONSTER)
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    local tc = g:GetFirst()
    Duel.CalculateDamage(c, tc)
end

function cm.con3(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsReason(REASON_DESTROY)
end

function cm.filter3(c, e, tp)
    return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and not c:IsCode(60001127)
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
            and Duel.IsExistingMatchingCard(cm.filter3, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g1 = Duel.SelectMatchingCard(tp, cm.filter3, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    Duel.SpecialSummon(g1, 0, tp, tp, false, false, POS_FACEUP)
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
