local m = 60001093
local cm = _G["c" .. m]
cm.name = "终末龙辉巧"

function cm.initial_effect(c)
    --ReturnDeck
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.filter1(c, rp, tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
        and (not c:IsSummonableCard()) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp == 1 - tp))
end

function cm.con1(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(cm.filter1, 1, nil, rp, tp)
end

function cm.filter2(c, tp)
    return c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and not c:IsSummonableCard()
end

function cm.con2(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(cm.filter2, 1, nil, tp) and (r & REASON_EFFECT) ~= 0 and rp ~= tp
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.SendtoDeck(eg, tp, 2, REASON_EFFECT)
    Duel.Draw(tp, 2, REASON_EFFECT)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e2:SetTargetRange(1, 0)
    e2:SetTarget(cm.splimit)
    e2:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e2, tp)
end

function cm.splimit(e, c)
    return c:IsSummonableCard()
end
