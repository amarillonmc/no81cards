local m = 60001100
local cm = _G["c" .. m]
cm.name = "SpaceR-LIGHT-sCalling"

function cm.initial_effect(c)
    --Active
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) >= 7 end
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x62f) and c:IsType(TYPE_MONSTER + TYPE_FUSION) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ct = 7
    local dt = 1
    Duel.ConfirmDecktop(tp, ct)
    local g1 = Duel.GetDecktopGroup(tp, 1)
    local g2 = Duel.GetDecktopGroup(tp, 7)
    local tc1 = g1:GetFirst()
    local tc2 = g2:GetFirst()
    while ct > 0 and tc1 and tc2 do
        if ct == 0 then Duel.BreakEffect() end
        if tc1:GetCode() == tc2:GetCode() then
            ct = 0
        else
            dt = dt + 1
            ct = ct - 1
            tc2 = g2:GetNext()
        end
    end
    if dt == 7 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g3 = Duel.SelectMatchingCard(tp, cm.filter1, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
        local tc3 = g3:GetFirst()
        if g3:GetCount() > 0 then
            Duel.SpecialSummon(tc3, 0, tp, tp, false, false, POS_FACEUP)
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_INDESTRUCTABLE)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            e1:SetValue(1)
            tc3:RegisterEffect(e1)
        end
    end
end
