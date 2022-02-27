local m = 60000090
local cm = _G["c" .. m]
cm.name = "光道下永绽的极光"

function cm.initial_effect(c)
    --Active
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.filter1(c)
    return c:IsDiscardable()
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter1, tp, LOCATION_HAND, 0, 2, nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, LOCATION_HAND)
end

function cm.filter2(c)
    return c:IsSetCard(0x38) and not c:IsCode(60000090)
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local p = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG, p, HINTMSG_DISCARD)
    local g1 = Duel.SelectMatchingCard(p, cm.filter1, p, LOCATION_HAND, 0, 1, 99, nil)
    Duel.SendtoGrave(g1, REASON_COST + REASON_DISCARD)
    local g2 = Duel.GetOperatedGroup()
    local ct = #g2
    local a = 0
    while Duel.IsPlayerCanDiscardDeck(tp, 1) and ct > 0 do
        if ct > 0 then Duel.BreakEffect() end
        Duel.ConfirmDecktop(tp, 1)
        local g = Duel.GetDecktopGroup(tp, 1)
        local tc = g:GetFirst()
        if not tc:IsSetCard(0x38) then
            Duel.DisableShuffleCheck()
            Duel.SendtoGrave(tc, REASON_EFFECT)
            if tc:IsLocation(LOCATION_GRAVE) then
                Duel.Damage(tp, 500, REASON_EFFECT)
            else ct = 0 end
        elseif tc:IsSetCard(0x38) then
            Duel.SendtoGrave(tc, REASON_EFFECT)
            ct = ct - 1
            a = a + 1
            if a >= 3 then
                Duel.Hint(HINT_SELECTMSG, p, HINTMSG_SELECT)
                local g3 = Duel.SelectMatchingCard(p, cm.filter2, p, LOCATION_GRAVE, 0, 1, 1, nil)
                Duel.SendtoHand(g3, tp, REASON_EFFECT)
            end
        end
    end
end
