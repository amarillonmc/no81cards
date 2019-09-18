--Sepialife - Peerless March
--Scripted by AlphaKretin
--For Nemoma
local s = c33701016
local id = 33701016
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
end
function s.cfilter(c)
    return c:IsFacedown() or not c:IsSetCard(0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return not Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
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
    if
        c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 and
            Duel.SelectYesNo(tp, aux.Stringid(id, 1))
     then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1, 0)
        e1:SetValue(3) --1 normal draw + 2 "additional" cards
        e1:SetReset(EVENT_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
        Duel.RegisterEffect(e1, tp)
    end
end
function s.recon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
