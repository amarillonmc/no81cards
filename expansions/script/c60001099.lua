local m = 60001099
local cm = _G["c" .. m]
cm.name = "LIGHT-Polymerization"

function cm.initial_effect(c)
    --Spsummon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(cm.cost1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(Card.IsAbleToGrave, tp, LOCATION_ONFIELD, 0, 2, nil, e, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g1 = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler(), e, tp)
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g1, 1, 0, 0)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x62f) and c:IsType(TYPE_MONSTER + TYPE_FUSION) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(tc, REASON_EFFECT, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g2 = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
    if #g2 > 0 then
        Duel.SpecialSummon(g2, 0, tp, tp, false, false, POS_FACEUP)
    end
end
