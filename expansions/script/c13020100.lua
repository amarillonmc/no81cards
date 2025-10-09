--精灵胶囊
local cm, m, o = GetID()
if not Duel.LoadScript and loadfile then
    function Duel.LoadScript(str)
        require_list = require_list or {}
        str = "expansions/script/" .. str
        if not require_list[str] then
            if string.find(str, "%.") then
                require_list[str] = loadfile(str)
            else
                require_list[str] = loadfile(str .. ".lua")
            end
            pcall(require_list[str])
        end
        return require_list[str]
    end
end
Duel.LoadScript("c16670000.lua")
function cm.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND + LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET + EFFECT_FLAG_SET_AVAILABLE)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        return (c:IsLocation(LOCATION_HAND) and
                (not Duel.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) or
                    Duel.IsExistingMatchingCard(function(c)
                        return c:IsType(TYPE_EQUIP) and c:IsFaceup()
                    end, tp, LOCATION_SZONE, 0, 1, nil))) or
            (not c:IsLocation(LOCATION_HAND) and Duel.IsMainPhase() and Duel.IsTurnPlayer(tp))
    end)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
        local c = e:GetHandler()
        local func = function(c)
            return (c:IsLocation(LOCATION_MZONE) or
                c:IsLocation(LOCATION_SZONE)) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsFaceup()
        end
        if chkc then
            return func(chkc)
        end
        if chk == 0 then
            return Duel.IsExistingTarget(func, tp, LOCATION_MZONE + LOCATION_SZONE,
                LOCATION_MZONE + LOCATION_SZONE, 1, nil)
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
        Duel.SelectTarget(tp, func, tp, LOCATION_MZONE + LOCATION_SZONE, LOCATION_MZONE + LOCATION_SZONE, 1, 1, c) --aux.ExceptThisCard(e)
        Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local tc = Duel.GetFirstTarget()
        if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            it.CopyEquip(tp, c, tc)
        end
    end)
    c:RegisterEffect(e1)
    it.EmulateSZONE(c, e1)

    local e29 = Effect.CreateEffect(c)
    e29:SetType(EFFECT_TYPE_EQUIP)
    e29:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e29)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    -- e2:SetValue(RESET_TURN_SET)
    c:RegisterEffect(e2)

    -- local e4 = Effect.CreateEffect(c)
    -- e4:SetDescription(aux.Stringid(m, 1))
    -- e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    -- e4:SetCode(EVENT_DESTROYED)
    -- e4:SetCondition(cm.setcon)
    -- e4:SetOperation(cm.setop)
    -- c:RegisterEffect(e4)

    local e11 = Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(m, 0))
    e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e11:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e11:SetProperty(EFFECT_FLAG_DELAY)
    e11:SetRange(0xfff)
    e11:SetCode(EVENT_EQUIP)
    e11:SetTarget(cm.sptg)
    e11:SetOperation(cm.spop)
    c:RegisterEffect(e11)
end

function cm.setcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsReason(REASON_LOST_TARGET)
        and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD + LOCATION_OVERLAY)
end

function cm.setop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 创立一个永续效果，下个回合的准备阶段将卡号为m的卡加入手卡
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e:SetCountLimit(1)
    e:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetTurnCount() ~= e:GetLabel()
    end)
    e:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local g = Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, nil, m)
        if #g > 0 then
            local tc = g:GetFirst()
            Duel.SendtoHand(tc, tp, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, tc)
            Duel.ShuffleHand(tp)
        end
        e:Reset()
    end)
    e:SetLabel(Duel.GetTurnCount())
    e:SetReset(RESET_PHASE + PHASE_STANDBY)
    Duel.RegisterEffect(e, tp)
end

function cm.filter(c, ec)
    return c == ec --c:GetEquipTarget() == ec and c:IsType(TYPE_SPELL + TYPE_TRAP)
end

function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local dg = eg:Filter(cm.filter, nil, e:GetHandler())
    local kx, zzx, sxx, zzjc, sxjc, zzl = it.sxbl()
    local tc2 = c:GetPreviousEquipTarget()
    if chk == 0 then return #dg > 0 and zzx > 0 and tc2 ~= nil and Duel.GetLocationCount(1 - tp, LOCATION_MZONE) > 0 end
    local zz, sx, lv = it.sxblx(tp, kx, zzx, sxx, zzl)
    e:SetLabel(zz, sx, lv)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, tc2, 1, 0, 0)
end

function cm.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local zz, sx, lv = e:GetLabel()
    local tc = c:GetPreviousEquipTarget()
    if not Duel.IsPlayerCanSpecialSummonMonster(tp, tc:GetCode(), 0, TYPE_NORMAL + TYPE_MONSTER, 0, 0, lv, zz, sx) then return end
    it.AddMonsterate(tc, TYPE_NORMAL + TYPE_MONSTER, sx, zz, lv, 0, 0)
    Duel.SpecialSummonStep(tc, 0, tp, 1 - tp, true, false, POS_FACEUP_ATTACK)
    Duel.SpecialSummonComplete()
end
