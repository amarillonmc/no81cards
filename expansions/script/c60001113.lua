local m = 60001113
local cm = _G["c" .. m]
cm.name = "圣兽装骑·蜂"

function cm.initial_effect(c)
    --Equip
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1, m)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, m)
    e2:SetTarget(cm.tg2)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)

    --BackToDeck
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCondition(cm.con3)
    e3:SetOperation(cm.op3)
    c:RegisterEffect(e3)
end

function cm.filter1(c, e, tp)
    return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) and cm.filter1(chkc) end
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingTarget(cm.filter1, tp, LOCATION_MZONE, 0, 1, e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, cm.filter1, tp, LOCATION_MZONE, 0, 1, 1, e:GetHandler())
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc = Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or tc:GetControler() ~= tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
        Duel.SendtoGrave(c, REASON_EFFECT)
        return
    end
    Duel.Equip(tp, c, tc)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
    e1:SetValue(cm.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end

function cm.eqlimit(e, c)
    return c == e:GetLabelObject()
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) and cm.filter1(chkc) end
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingTarget(cm.filter1, tp, LOCATION_MZONE, 0, 1, e:GetHandler())
            and not Duel.IsPlayerAffectedByEffect(tp, m)
    end
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(m)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_CANNOT_DISABLE)
    e2:SetTargetRange(1, 0)
    Duel.RegisterEffect(e2, tp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, cm.filter1, tp, LOCATION_MZONE, 0, 1, 1, e:GetHandler())
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc = Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or tc:GetControler() ~= tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
        Duel.SendtoGrave(c, REASON_EFFECT)
        return
    end
    Duel.Equip(tp, c, tc)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
    e1:SetValue(cm.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end

function cm.con3(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsLocation(LOCATION_DECK)
end

function cm.op3(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.SendtoDeck(c, tp, 2, REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g1 = Duel.SelectMatchingCard(tp, cm.filter2, tp, LOCATION_DECK, 0, 1, 1, nil)
    Duel.SendtoHand(g1, tp, REASON_EFFECT)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e2:SetTargetRange(1, 0)
    e2:SetTarget(cm.splimit)
    e2:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e2, tp)
end

function cm.filter2(c, e, tp)
    return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER) and not c:IsCode(60001113)
end

function cm.splimit(e, c)
    return not c:IsAttribute(ATTRIBUTE_WATER)
end
