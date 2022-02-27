local m = 60001092
local cm = _G["c" .. m]
cm.name = "辉巧星堕地"

function cm.initial_effect(c)
    --Spsummon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, m)
    e1:SetCost(cm.cost1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(nil, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler(), e, tp)
    Duel.SendtoGrave(g, REASON_EFFECT, tp)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x154) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_HAND, 0, 1, nil, e, tp)
    end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local tg = Duel.GetMatchingGroup(cm.filter1, tp, LOCATION_HAND, 0, nil, e, tp)
    if ft <= 0 or #tg == 0 then return end
    local g = tg:Select(tp, 1, ft, nil)
    for tc in aux.Next(g) do
        Duel.SpecialSummonStep(tc, 0, tp, tp, true, true, POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
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
    return c:IsSummonableCard()
end
