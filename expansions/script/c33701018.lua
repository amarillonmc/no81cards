--Sepialife - Void Nocturne
--Scripted by AlphaKretin
--For Nemoma
local s = c33701018
local id = 33701018
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c, nil, 2, 3, s.lcheck)
    --special summon self
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --double atk
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
    --special summon other
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_TOHAND + CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
function s.lcheck(g, lc, tp)
    return g:IsExists(Card.IsLinkSetCard, 1, nil, 0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local ns, ss = Duel.GetActivityCount(tp, ACTIVITY_SUMMON, ACTIVITY_SPSUMMON)
    return Duel.GetTurnPlayer() == tp and ns + ss == 0
end
function s.spfilter(c)
    return c:IsSetCard(0x144e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.MZFilter(c, tp)
    return c:IsLocation(LOCATION_MZONE) and c:GetSequence() < 5 and c:IsControler(tp)
end
function s.ChkfMMZ(sumcount)
    return function(sg, e, tp, mg)
        return sg:FilterCount(s.MZFilter, nil, tp) + Duel.GetLocationCount(tp, LOCATION_MZONE) >= sumcount
    end
end
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    local rg = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_HAND + LOCATION_MZONE + LOCATION_GRAVE, 0, e:GetHandler())
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > -3 and #rg > 1 and
            aux.SelectUnselectGroup(rg, e, tp, 3, 3, s.ChkfMMZ(1), 0)
    end
    local g = aux.SelectUnselectGroup(rg, e, tp, 3, 3, s.ChkfMMZ(1), 1, tp, HINTMSG_REMOVE)
    Duel.Remove(g, POS_FACEUP, REASON_COST)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
        c:CompleteProcedure()
        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 0)
    end
end
function s.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(s.atkfilter, tp, LOCATION_MZONE, 0, nil)
    local c = e:GetHandler()
    if c:GetFlagEffect(id) == 0 then
        return
    end
    for tc in aux.Next(g) do
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        e1:SetValue(tc:GetAttack() * 2)
        tc:RegisterEffect(e1)
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD)
        e2:SetValue(tc:GetDefense() * 2)
        tc:RegisterEffect(e2)
    end
end
function s.thfilter(c)
    return c:IsSetCard(0x144e) and c:IsAbleToHand()
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_REMOVED, 0, 1, nil) and Duel.IsPlayerCanDraw(tp, 1)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_REMOVED)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 1, tp, 0)
end
function s.thop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_REMOVED, 0, 1, 1, nil)
    if #g > 0 and Duel.SendtoHand(g, nil, REASON_EFFECT + REASON_RETURN) ~= 0 then
        Duel.Draw(tp, 1, REASON_EFFECT)
    end
end
