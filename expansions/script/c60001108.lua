local m = 60001108
local cm = _G["c" .. m]
cm.name = "圣兽装骑·骸-等候"

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

    --Destroy
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1, m + 1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetTarget(cm.tg3)
    e1:SetOperation(cm.op3)
    c:RegisterEffect(e1)
end

function cm.filter1(c)
    return c:IsSetCard(0x962e) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and not Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_MZONE, 0, 1, nil)
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
            and not Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_MZONE, 0, 1, nil)
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

function cm.con3(sg, e, tp, mg)
    return sg:IsExists(Card.IsControler, 1, nil, tp)
end

function cm.tg3(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return false end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_ONFIELD, 0, 1, nil)
            and Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g1 = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g2 = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g1, 2, 0, 0)
end

function cm.filter3(c)
    return c:GetPreviousRaceOnField() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x62e)
end

function cm.filter4(c)
    return c:IsSetCard(0x962e) and c:IsType(TYPE_MONSTER)
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    local tg = g:Filter(Card.IsRelateToEffect, nil, e)
    if #tg > 0 and Duel.Destroy(tg, REASON_EFFECT) ~= 0 then
        local sg = Duel.GetOperatedGroup():Filter(cm.filter3, 1, nil)
        if #sg > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
            local g2 = Duel.SelectMatchingCard(tp, cm.filter4, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp, nil)
            Duel.SendtoHand(g2, tp, REASON_EFFECT)
        end
    end
end
