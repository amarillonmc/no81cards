--VTuber Mochi Hiyoko
--AlphaKretin
--For Nemoma
local s = c33700413
local id = 33700413
function s.initial_effect(c)
    c:SetUniqueOnField(1, 1, aux.FilterBoolFunction(Card.IsCode, id), LOCATION_MZONE)
    --synchro summon
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(
        c,
        aux.FilterBoolFunction(Card.IsAttackBelow, 500),
        --1,
        --1,
        aux.NonTuner(Card.IsAttackBelow, 500),
        1,
        99
    )
    --Gain ATK
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(2500)
    c:RegisterEffect(e1)
    --Activate other effect
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)
end
function s.getValidIgnitionEffects(c, e, tp, eg, ep, ev, re, r, rp, chk)
    local effs = {c:GetCardEffect()}
    local validEffs = {}
    for _, eff in ipairs(effs) do
        if
            eff:GetType() & EFFECT_TYPE_IGNITION == EFFECT_TYPE_IGNITION or
                eff:GetType() & EFFECT_TYPE_QUICK_O == EFFECT_TYPE_QUICK_O
         then
            local con = eff:GetCondition()
            local cost = eff:GetCost()
            local tg = eff:GetTarget()
            local event = eff:GetCode()
            if
                (not con or con(e, tp, eg, ep, ev, re, r, rp)) and (not cost or cost(e, tp, eg, ep, ev, re, r, rp, chk)) and
                    (not tg or tg(e, tp, eg, ep, ev, re, r, rp, chk)) and
                    (not event or event == EVENT_FREE_CHAIN)
             then
                validEffs[#validEffs + 1] = eff
            end
        end
    end
    return validEffs
end
function s.filter(c, e, tp, eg, ep, ev, re, r, rp, chk)
    return #s.getValidIgnitionEffects(c, e, tp, eg, ep, ev, re, r, rp, chk) > 0
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil, e, tp, eg, ep, ev, re, r, rp, chk)
    end
    local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_MZONE, 0, nil, e, tp, eg, ep, ev, re, r, rp, 0)
    local tc = g:Select(tp, 1, 1, nil):GetFirst()
    local sel = 1
    local effs = card.getValidIgnitionEffects(tc, e, tp, eg, ep, ev, re, r, rp, 0)
    if #effs > 1 then
        local descs = {}
        for _, eff in ipairs(effs) do
            descs[#descs + 1] = eff:GetDescription()
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
        sel = Duel.SelectOption(tp, table.unpack(descs)) + 1
    end
    local eff = effs[sel]
    e:SetLabelObject(eff)
    local cost = eff:GetCost()
    local tg = eff:GetTarget()
    if cost then
        cost(e, tp, eg, ep, ev, re, r, rp, 1)
    end
    if tg then
        tg(e, tp, eg, ep, ev, re, r, rp, 1)
    end
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    e:GetLabelObject():GetOperation()(e, tp, eg, ep, ev, re, r, rp)
end
