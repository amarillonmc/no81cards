function c11845775.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE + CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1, 11845775 + EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c11845775.condition)
    e1:SetTarget(aux.nbtg)
    e1:SetOperation(c11845775.activate)
    c:RegisterEffect(e1)
end

function c11845775.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xf80)
end

function c11845775.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(c11845775.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end

function c11845775.activate(e, tp, eg, ep, ev, re, r, rp)
    local tc = re:GetHandler()
    if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
        Duel.SendtoDeck(eg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
    end
end