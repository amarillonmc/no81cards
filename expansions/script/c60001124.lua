local m = 60001124
local cm = _G["c" .. m]
cm.name = "圣兽装骑·蜂-枪型"

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

    --Unequip
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    e3:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e3)
end

function cm.filter1(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) and cm.filter1(chkc) end
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingTarget(cm.filter1, tp, 0, LOCATION_MZONE, 1, e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, cm.filter1, tp, 0, LOCATION_MZONE, 1, 1, e:GetHandler())
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc = Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or tc:GetControler() ~= 1 - tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
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
    --unequip
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e3:SetTargetRange(1, 0)
    e3:SetTarget(cm.splimit)
    e3:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e3, tp)
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) and cm.filter1(chkc) end
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingTarget(cm.filter1, tp, 0, LOCATION_MZONE, 1, e:GetHandler())
            and not Duel.IsPlayerAffectedByEffect(tp, m)
    end
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(m)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_CANNOT_DISABLE)
    e2:SetTargetRange(1, 0)
    Duel.RegisterEffect(e2, tp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, cm.filter1, tp, 0, LOCATION_MZONE, 1, 1, e:GetHandler())
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc = Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or tc:GetControler() ~= 1 - tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
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
    --unequip
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e3:SetTargetRange(1, 0)
    e3:SetTarget(cm.splimit)
    e3:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e3, tp)
end

function cm.splimit(e, c)
    return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.eqlimit(e, c)
    return c == e:GetLabelObject()
end

function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():GetFlagEffect(93108839) == 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, true, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
    e:GetHandler():RegisterFlagEffect(93108839, RESET_EVENT + 0x7e0000 + RESET_PHASE + PHASE_END, 0, 1)
end

function cm.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc = c:GetEquipTarget()
    if Duel.SpecialSummon(c, 0, tp, tp, true, false, POS_FACEUP) ~= 0 then
        Duel.SendtoGrave(tc, REASON_EFFECT)
    end
end

function cm.filter3(c, e, tp)
    return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
