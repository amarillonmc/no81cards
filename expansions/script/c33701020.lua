--Sepialife - Frozen Reverdie
--Scripted by AlphaKretin
--For Nemoma
local s = c33701020
local id = 33701020
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0x144e), 3, false)
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
    --end phase
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOGRAVE + CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.tgcon)
    e2:SetTarget(s.tgtg)
    e2:SetOperation(s.tgop)
    c:RegisterEffect(e2)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local ct = Duel.GetActivityCount(tp, ACTIVITY_BATTLE_PHASE)
    return Duel.GetTurnPlayer() == tp and ct == 0
end
function s.matfilter(c)
    return c:IsSetCard(0x144e) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsCanBeSpecialSummoned(e, 0, tp, true, true) and
            Duel.IsExistingMatchingCard(s.matfilter, tp, LOCATION_GRAVE, 0, 3, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 3, tp, LOCATION_GRAVE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_GRAVE, 0, 3, 3, nil)
    if #g > 2 and Duel.SendtoDeck(g, nil, 2, REASON_EFFECT) > 2 then
        if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
            c:CompleteProcedure()
        end
    end
end
function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentPhase() == PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.tgfilter(c)
    return c:IsSetCard(0x144e) and c:IsAbleToGrave()
end
function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
    local g = Duel.GetMatchingGroup(s.tgfilter, tp, LOCATION_DECK, 0, nil)
    if chk == 0 then
        return g:CheckSubGroup(aux.dncheck, 1, 4)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, 1, 0, 0)
end
function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(s.tgfilter, tp, LOCATION_DECK, 0, nil, e, tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local dg = g:SelectSubGroup(aux.dncheck, tp, 1, 4)
    if #dg > 0 then
        local ct = Duel.SendtoGrave(dg, REASON_EFFECT)
        if ct > 0 and Duel.Recover(tp, ct * 1000, REASON_EFFECT) > 0 then
            Duel.BreakEffect()
            Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE + PHASE_END, 1)
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetTargetRange(1, 0)
            e1:SetCode(EFFECT_CANNOT_BP)
            e1:SetReset(RESET_PHASE + PHASE_END)
            Duel.RegisterEffect(e1, tp)
        end
    end
end
