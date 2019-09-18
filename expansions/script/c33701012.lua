--Sepialife - Lonely Suite
--Scripted by AlphaKretin
--For Nemoma
local s = c33701012
local id = 33701012
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
    --special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --damage
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1, id)
    e2:SetCondition(s.damcon)
    e2:SetTarget(s.damtg)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
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
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
        --Cannot be destroyed
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetTargetRange(LOCATION_MZONE, 0)
        e1:SetTarget(s.indtg)
        e1:SetValue(s.indval)
        e1:SetReset(RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
        Duel.RegisterEffect(e1, tp)
        --No damage
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetTargetRange(1, 0)
        e2:SetValue(1)
        e2:SetReset(RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
        Duel.RegisterEffect(e2, tp)
    end
end
function s.indtg(e, c)
    return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.indval(e, re, rp)
    return rp ~= e:GetHandlerPlayer()
end
function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and Duel.GetActivityCount(tp, ACTIVITY_BATTLE_PHASE) == 0
end
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(1700)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1700)
end
function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
end
