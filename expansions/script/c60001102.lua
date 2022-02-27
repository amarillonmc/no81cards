local m = 60001102
local cm = _G["c" .. m]
cm.name = "穿透于星遗物的悲歌"

function cm.initial_effect(c)
    --Active
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.filter1(c, e)
    return c:IsSetCard(0xfe) and c:IsType(TYPE_MONSTER)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return eg:IsExists(cm.filter1, 1, nil, tp) end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g1 = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 2, 2, nil)
    local tc1 = g1:GetFirst()
    Duel.SpecialSummon(g1, 0, tp, tp, false, false, POS_FACEUP)
    local turn = 0
    local a = 0
    local b = 0
    a = tc1:GetLevel()
    tc1 = g1:GetNext()
    b = tc1:GetLevel()
    if a >= 5 or b >= 5 then
        if Duel.GetTurnPlayer() == 1 - tp then
            turn = 1
        else
            turn = 3
        end
    end
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(cm.con2)
    e1:SetTarget(cm.tg2)
    e1:SetOperation(cm.op2)
    e1:SetCountLimit(turn)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
end

function cm.con2(e, tp, eg, ep, ev, re, r, rp)
    local ch = Duel.GetCurrentChain(true) - 1
    if ch <= 0 then return false end
    local cplayer = Duel.GetChainInfo(ch, CHAININFO_TRIGGERING_CONTROLER)
    local ceff = Duel.GetChainInfo(ch, CHAININFO_TRIGGERING_EFFECT)
    if re:GetHandler():IsDisabled() or not Duel.IsChainDisablable(ev) then return false end
    return ep == 1 - tp and cplayer == tp and (ceff:GetHandler():IsSetCard(0xfefd) or ceff:GetHandler():IsSetCard(0xfd))
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
    end
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg, REASON_EFFECT)
    end
end
