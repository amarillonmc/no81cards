--Sepialife - Blind Devinalh
--Scripted by AlphaKretin
--For Nemoma
local s = c33701019
local id = 33701019
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c, nil, 4, 2, nil, nil, 99, nil, false, s.xcheck)
    --special summon self
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --draw
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.drcon)
    e2:SetCost(s.drcost)
    e2:SetTarget(s.drtg)
    e2:SetOperation(s.drop)
    c:RegisterEffect(e2)
end
function s.xcheck(g, lc, tp)
    return g:IsExists(Card.IsXyzSetCard, 1, nil, 0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local ct = Duel.GetActivityCount(tp, ACTIVITY_CHAIN)
    return Duel.GetTurnPlayer() == tp and ct == 0
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsCanBeSpecialSummoned(e, 0, tp, true, true) and
            Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_GRAVE, 0, 2, nil, 0x144e)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
        c:CompleteProcedure()
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
        local g = Duel.SelectMatchingCard(tp, Card.IsSetCard, tp, LOCATION_GRAVE, 0, 2, 2, nil, 0x144e)
        if #g > 0 then
            Duel.Overlay(c, g)
        end
    end
end
function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return tp == Duel.GetTurnPlayer()
end
function s.drcost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:CheckRemoveOverlayCard(tp, 1, REASON_COST)
    end
    c:RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(tp, 3)
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(3)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 3)
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    if Duel.Draw(p, d, REASON_EFFECT) == 3 then
        Duel.ShuffleHand(p)
        Duel.BreakEffect()
        Duel.SkipPhase(tp, PHASE_DRAW, RESET_PHASE + PHASE_END, 1)
        Duel.SkipPhase(tp, PHASE_STANDBY, RESET_PHASE + PHASE_END, 1)
        Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE + PHASE_END, 1)
        Duel.SkipPhase(tp, PHASE_BATTLE, RESET_PHASE + PHASE_END, 1, 1)
        Duel.SkipPhase(tp, PHASE_MAIN2, RESET_PHASE + PHASE_END, 1)
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_BP)
        e1:SetTargetRange(0, 1)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end
