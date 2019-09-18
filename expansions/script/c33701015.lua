--Sepialife - Blank Scherzo
--Scripted by AlphaKretin
--For Nemoma
local s = c33701015
local id = 33701015
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
    --Draw
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetOperation(s.regop)
    c:RegisterEffect(e2)
    if not s.global_flag then
        s.global_flag = true
        s[0] = 0
        s[1] = 0
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_TO_HAND)
        ge1:SetOperation(s.ctop)
        Duel.RegisterEffect(ge1, 0)
        local ge2 = Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_PHASE + PHASE_DRAW)
        ge2:SetCountLimit(1)
        ge2:SetCondition(s.resetop)
        Duel.RegisterEffect(ge2, 0)
    end
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return s[tp] == 0
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and
            Duel.IsPlayerCanDraw(tp, 2)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 2, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP_ATTACK) ~= 0 then
        Duel.Draw(tp, 2, REASON_EFFECT)
    end
end
function s.ctfilter(c)
    return not (c:IsReason(REASON_DRAW) or c:IsSetCard(0x144e))
end
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
    s[tp] = s[tp] + eg:FilterCount(s.ctfilter, nil)
end
function s.resetop(e, tp, eg, ep, ev, re, r, rp)
    s[0] = 0
    s[1] = 0
    return false
end
function s.regop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsFacedown() or not c:IsSummonType(SUMMON_TYPE_SPECIAL) or Duel.GetTurnPlayer() == effp then
        return
    end
    local effp = c:GetControler()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(s.chainreg)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, effp)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.drcon)
    e2:SetOperation(s.drop)
    e2:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e2, effp)
end
function s.chainreg(e, tp, eg, ep, ev, re, r, rp)
    e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + 0x1fc0000 + RESET_CHAIN, 0, 1)
end
function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return ep ~= tp and e:GetHandler():GetFlagEffect(id) ~= 0
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_CARD, 0, id)
    Duel.Draw(tp, 1, REASON_EFFECT)
end
