-- 永恒流星之烁炎 凯撒·武装
local s, id = GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)	

    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
    e1:SetHintTiming(TIMING_MAIN_END, TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(46046112)
    c:RegisterEffect(e2)

    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1, id+1)
    e3:SetCondition(s.tgcon)
    e3:SetTarget(s.tgtg)
    e3:SetOperation(s.tgop)
    c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        local g = Duel.GetMatchingGroup(s.costfilter, tp, LOCATION_HAND + LOCATION_ONFIELD , 0, nil, e, tp)
        return #g >= 2 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    if Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil) then
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 1 - tp, LOCATION_ONFIELD)
    end
end

function s.costfilter(c, e, tp)
    return c:IsSetCard(0x6f8) and not c:IsCode(id) and c:IsAbleToGrave()
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 2, 2, nil, e, tp)
    if #g ~= 2 then return end
    if Duel.SendtoGrave(g, REASON_EFFECT) == 0 then return end
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        if Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
            local tg = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
            if #tg > 0 then
                Duel.Destroy(tg, REASON_EFFECT)
            end
        end
    end
end

function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end

function s.tgfilter(c)
    return c:IsSetCard(0x6f8) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end
