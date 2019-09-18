--Living the Sepialife
--Scripted by AlphaKretin
--For Nemoma
local s = c33701022
local id = 33701022
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --special summon
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0, TIMING_END_PHASE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --gain LP
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(s.lpcost)
    e3:SetTarget(s.lptg)
    e3:SetOperation(s.lpop)
    c:RegisterEffect(e3)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    if s.spcon(e, tp, eg, ep, ev, re, r, rp) and s.sptg(e, tp, eg, ep, ev, re, r, rp, 0) and Duel.SelectYesNo(tp, 94) then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e:SetOperation(s.spop)
        s.sptg(e, tp, eg, ep, ev, re, r, rp, 1)
    else
        e:SetCategory(0)
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() ~= tp
end
function s.spfilter(c, e, tp)
    return c:IsSetCard(0x144e) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc, e, tp)
    end
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
            Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, LOCATION_GRAVE)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then
        return
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g > 0 and Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
        e1:SetCode(EVENT_PHASE + PHASE_END)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE + PHASE_END)
        e1:SetOperation(s.thop)
        Duel.RegisterEffect(e1, tp)
    end
end
function s.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x144e) and c:IsAbleToHand()
end
function s.thop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_CARD, 0, id)
    local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_MZONE, 0, nil)
    if #g > 0 then
        local ct = Duel.SendtoHand(g, nil, REASON_EFFECT)
        if ct > 0 then
            Duel.Recover(tp, ct * 500, REASON_EFFECT)
        end
    end
end
function s.tdfilter(c)
    return c:IsSetCard(0x144e) and c:IsAbleToDeckAsCost()
end
function s.lpcost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return aux.bfgcost(e, tp, eg, ep, ev, re, r, rp, chk) and
            Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_GRAVE, 0, 2, c)
    end
    aux.bfgcost(e, tp, eg, ep, ec, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 2, 2, c)
    Duel.SendtoDeck(g, nil, 2, REASON_COST)
end
function s.lptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1200)
    Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 1200)
end
function s.lpop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Recover(p, d, REASON_EFFECT)
end
