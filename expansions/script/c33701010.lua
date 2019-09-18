--Sepialife - Muted Sonata
--Scripted by AlphaKretin
--For Nemoma
local s = c33701010
local id = 33701010
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
    --Special Summon
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
    --Redirect
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(s.recon)
    e2:SetValue(LOCATION_HAND)
    c:RegisterEffect(e2)
end
function s.counterfilter(c)
    return c:IsSetCard(0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SUMMON) + Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) ==
        0
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end
function s.recon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
