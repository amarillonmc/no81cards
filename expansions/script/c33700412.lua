--Lily White, Spring Caller
--AlphaKretin
--For Nemoma
local s = c33700412
local id = 33700412
local CTR_PETAL = 0x234
function s.initial_effect(c)
    c:EnableCounterPermit(CTR_PETAL)
    --synchro summon
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(
        c,
        aux.FilterBoolFunction(aux.NOT(Card.IsAttribute, ATTRIBUTE_DARK)),
        1,
        1,
        aux.NonTuner(aux.NOT(Card.IsAttribute), ATTRIBUTE_DARK),
        2,
        99
    )
    --indes
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --add counter
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.ctcon)
    e2:SetTarget(s.cttg)
    e2:SetOperation(s.ctop)
    c:RegisterEffect(e2)
    --change target
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.tgcon)
    e3:SetTarget(s.tgtg)
    e3:SetOperation(s.tgop)
    c:RegisterEffect(e3)
    --negate
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 2))
    e4:SetCategory(CATEGORY_DISABLE + CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_BECOME_TARGET)
    e4:SetCondition(s.negcon)
    e4:SetTarget(s.negtg)
    e4:SetOperation(s.negop)
    c:RegisterEffect(e4)
    --end battle phase
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id, 3))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(s.bpcon)
    e5:SetTarget(s.bptg)
    e5:SetOperation(s.bpop)
    c:RegisterEffect(e5)
end
function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 2, 0, CTR_PETAL)
end
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:AddCounter(CTR_PETAL, 2)
    end
end
function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if (e == re) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or (rp == tp) or not g or (#g ~= 1) then
        return false
    end
    local tc = g:GetFirst()
    return tc:IsOnField() and tc:IsLocation(LOCATION_MZONE) and not tc==e:GetHandler()
end
function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    local tf = re:GetTarget()
    local res, ceg, cep, cev, cre, cr, crp = Duel.CheckEvent(re:GetCode(), true)
    if chk == 0 then
        return c:IsCanAddCounter(CTR_PETAL, 1) and tf(re, rp, ceg, cep, cev, cre, cr, crp, 0, c)
    end
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 1, 0, CTR_PETAL)
end
function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:AddCounter(CTR_PETAL, 1) then
        Duel.ChangeTargetCard(ev, Group.FromCards(c))
    end
end
function s.negcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsContains(e:GetHandler()) and rp == (1 - tp)
end
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsCanRemoveCounter(tp, CTR_PETAL, 1, REASON_EFFECT)
    end
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 1, 0, CTR_PETAL)
end
function s.negop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveCounter(tp, CTR_PETAL, 1, REASON_EFFECT) then
        Duel.NegateEffect(ev)
    end
end
function s.bpcon(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetTurnPlayer() ~= tp) and
        (Duel.GetCurrentPhase() >= PHASE_BATTLE_START) and (Duel.GetCurrentPhase() <= PHASE_BATTLE)
end
function s.bptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsCanRemoveCounter(tp, CTR_PETAL, 1, REASON_EFFECT)
    end
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 1, 0, CTR_PETAL)
end
function s.bpop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveCounter(tp, CTR_PETAL, 1, REASON_EFFECT) then
        Duel.SkipPhase(1 - tp, PHASE_BATTLE, RESET_PHASE + PHASE_BATTLE, 1)
    end
end
