--Sepialife - Dimmed Concerto
--Scripted by AlphaKretin
--For Nemoma
local s = c33701013
local id = 33701013
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
    --Change ATK
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
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
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetTargetRange(LOCATION_MZONE, 0)
        e1:SetTarget(s.indtg)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
        Duel.RegisterEffect(e1, tp)
        --No damage
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetTargetRange(0, LOCATION_MZONE)
        e2:SetValue(-1500)
        e2:SetReset(RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
        Duel.RegisterEffect(e2, tp)
        local e3 = e2:Clone()
        e3:SetCode(EFFECT_UPDATE_DEFENSE)
        Duel.RegisterEffect(e3, tp)
    end
end
function s.indtg(e, c)
    return c:IsFaceup() and c:IsSetCard(0x144e)
end
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and Duel.GetActivityCount(tp, ACTIVITY_BATTLE_PHASE) == 0
end
function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil)
    end
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
    for tc in aux.Next(g) do
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        tc:RegisterEffect(e2)
    end
end
