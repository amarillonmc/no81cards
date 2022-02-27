local m = 60001091
local cm = _G["c" .. m]
cm.name = "闪耀辉巧途"

function cm.initial_effect(c)
    --Lp
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, m)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x154) and c:IsType(TYPE_MONSTER + TYPE_RITUAL)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_MZONE, 0, 1, nil, e, tp) end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    local g = Duel.SelectTarget(tp, cm.filter1, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
    local tc = g:GetFirst()
    local code = tc:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetLabel(code)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op2)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e2:SetTargetRange(1, 0)
    e2:SetTarget(cm.splimit)
    e2:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e2, tp)
end

function cm.filter2(c, code)
    return c:IsSetCard(0x154) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsCode(code)
end

function cm.con1(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(cm.filter2, 1, nil, e:GetLabel())
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    Duel.SetLP(1 - tp, math.ceil(Duel.GetLP(1 - tp) / 2))
end

function cm.splimit(e, c)
    return c:IsSummonableCard()
end
