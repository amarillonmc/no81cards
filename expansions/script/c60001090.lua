local m = 60001090
local cm = _G["c" .. m]
cm.name = "辉巧星座雨"

function cm.initial_effect(c)
    --Attack
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
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD, nil)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x154)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
    local tc = g:GetFirst()
    if tc then
        Duel.SendtoGrave(tc, REASON_EFFECT, tp)
    end
    local dg = Duel.GetMatchingGroup(Card.IsCode, tp, 0x3ff, 0x3ff, nil, tc:GetCode())
    for sc in aux.Next(dg) do
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_PHASE + PHASE_END)
        e1:SetValue(2000)
        sc:RegisterEffect(e1)
    end
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
