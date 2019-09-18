--Sepialife - Dazed Impromptu
--Scripted by AlphaKretin
--For Nemoma
local s = c33701014
local id = 33701014
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
    --Special Summon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND + CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --atk up
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetType(EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e2:SetCountLimit(1)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
function s.spcfilter(c, tp)
    return c:IsReason(REASON_BATTLE + REASON_EFFECT) and c:GetPreviousControler() == tp and
        c:IsPreviousLocation(LOCATION_ONFIELD) and
        c:IsType(TYPE_MONSTER) and
        c:IsSetCard(0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.spcfilter, 1, nil, tp)
end
function s.thfilter(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    local sg = Duel.GetMatchingGroup(s.thfilter, tp, 0, LOCATION_ONFIELD, nil)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, sg, #sg, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP_ATTACK) ~= 0 then
        local mg = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
        for tc in aux.Next(mg) do
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(tc:GetAttack() // 2)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2 = e1:Clone()
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            e2:SetValue(tc:GetDefense() // 2)
            tc:RegisterEffect(e2)
        end
        local sg = Duel.GetMatchingGroup(s.thfilter, tp, 0, LOCATION_ONFIELD, nil)
        if #sg > 0 then
            Duel.SendtoHand(sg, nil, REASON_EFFECT)
        end
    end
end
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
        c:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end
