--蒹葭苍苍
local cm, m, ofs = GetID()
local yr = 13020010
-- xpcall(function() dofile("expansions/script/c16670000.lua") end, function() dofile("script/c16670000.lua") end)
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
    aux.AddCodeList(c, yr)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m, 2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(QY_mx)
    e3:SetCountLimit(1, m + 1)
    e3:SetCondition(cm.spcon2)
    -- e3:SetCost(cm.spcost2)
    e3:SetTarget(cm.sptg2)
    e3:SetOperation(cm.spop2)
    c:RegisterEffect(e3)
end

function cm.filter(c)
    return aux.IsCodeListed(c, yr) and c:IsAbleToHand()
end

function cm.filter2(c, e, tp)
    return c:IsType(TYPE_EQUIP) and c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function cm.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

function cm.cfilter(c, tp)
    return c:IsType(TYPE_NORMAL)
end

function cm.spcon2(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(cm.cfilter, 1, nil, tp)
end

function cm.spcost2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

function cm.sptg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_SPELL + TYPE_EQUIP) end
    local kx, zzx, sxx, zzjc, sxjc, zzl = it.sxbl()
    if chk == 0 then return Duel.IsExistingTarget(cm.filter2, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) and zzx > 0 end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectTarget(tp, cm.filter2, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    local zz, sx, lv = it.sxblx(tp, kx, zzx, sxx, zzl)
    e:SetLabel(zz, sx, lv)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function cm.spop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    local zz, sx, lv = e:GetLabel()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        if not Duel.IsPlayerCanSpecialSummonMonster(tp, tc:GetCode(), 0, TYPE_NORMAL + TYPE_MONSTER, 0, 0, lv, zz, sx) then return end
        it.AddMonsterate(tc, TYPE_NORMAL + TYPE_MONSTER, sx, zz, lv, 0, 0)
        Duel.SpecialSummonStep(tc, 0, tp, tp, true, false, POS_FACEUP_DEFENSE)
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetReset(RESET_EVENT + RESETS_REDIRECT)
        e3:SetValue(LOCATION_REMOVED)
        tc:RegisterEffect(e3, true)
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetReset(RESET_EVENT + RESETS_REDIRECT)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetValue(cm.atkval)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
        local cl = Duel.GetMatchingGroup(function(c)
            return c:IsXyzSummonable(nil) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, false, false)
        end, tp, LOCATION_EXTRA, 0, 1, nil)
        local lj = Duel.GetMatchingGroup(function(c)
            return c:IsLinkSummonable(nil) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_LINK, tp, false, false)
        end, tp, LOCATION_EXTRA, 0, 1, nil)
        local td = Duel.GetMatchingGroup(function(c)
            return c:IsSynchroSummonable(nil) and
                c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, false, false)
        end, tp, LOCATION_EXTRA, 0, 1, nil)
        local mg1 = Duel.GetFusionMaterial(tp):Filter(function(c)
            return not c:IsImmuneToEffect(e)
        end, nil)
        local rh = Duel.GetMatchingGroup(function(c)
            return c:CheckFusionMaterial(mg1, nil, tp) and
                c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
        end, tp, LOCATION_EXTRA, 0, 1, nil)
        if (cl:GetCount() > 0 or lj:GetCount() > 0 or td:GetCount() > 0 or rh:GetCount() > 0) and Duel.SelectYesNo(tp, aux.Stringid(m, 0)) then
            local off = 1
            local ops = {}
            local opval = {}
            if td then
                ops[off] = aux.Stringid(m, 3)
                opval[off - 1] = 1
                off = off + 1
            end
            if cl then
                ops[off] = aux.Stringid(m, 4)
                opval[off - 1] = 2
                off = off + 1
            end
            if lj then
                ops[off] = aux.Stringid(m, 5)
                opval[off - 1] = 3
                off = off + 1
            end
            if rh then
                ops[off] = aux.Stringid(m, 6)
                opval[off - 1] = 3
                off = off + 1
            end
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
            local op = Duel.SelectOption(tp, table.unpack(ops))
            if opval[op] == 1 then
                local tc = td:Select(tp, 1, 1, nil):GetFirst()
                if tc then
                    Duel.SynchroSummon(tp, tc, nil)
                end
            elseif opval[op] == 2 then
                local tc = cl:Select(tp, 1, 1, nil):GetFirst()
                if tc then
                    Duel.XyzSummon(tp, tc, nil)
                end
            elseif opval[op] == 3 then
                local tc = lj:Select(tp, 1, 1, nil):GetFirst()
                if tc then
                    Duel.LinkSummon(tp, tc, nil)
                end
            elseif opval[op] == 4 then
                local chkf = tp
                local mg2 = nil
                local sg2 = nil
                local ce = Duel.GetChainMaterial(tp)
                if ce ~= nil then
                    local fgroup = ce:GetTarget()
                    mg2 = fgroup(ce, e, tp)
                    local mf = ce:GetValue()
                    sg2 = Duel.GetMatchingGroup(function(c, e, tp, m, f, chkf)
                        return c:IsType(TYPE_FUSION) and (not f or f(c))
                            and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) and
                            c:CheckFusionMaterial(m, nil, chkf)
                    end, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, mf, chkf)
                end
                if rh:GetCount() > 0 or (sg2 ~= nil and sg2:GetCount() > 0) then
                    local sg = rh:Clone()
                    if sg2 then sg:Merge(sg2) end
                    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                    local tg = sg:Select(tp, 1, 1, nil)
                    local tc = tg:GetFirst()
                    if rh:IsContains(tc) and (sg2 == nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
                        local mat1 = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
                        tc:SetMaterial(mat1)
                        Duel.SendtoGrave(mat1, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
                        Duel.BreakEffect()
                        Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
                    else
                        local mat2 = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf)
                        local fop = ce:GetOperation()
                        fop(ce, e, tp, tc, mat2)
                    end
                    tc:CompleteProcedure()
                end
            end
        end
    end
end

function cm.atkval(e, c)
    return Duel.GetMatchingGroupCount(cm.atkfilter, e:GetHandlerPlayer(), LOCATION_GRAVE + LOCATION_REMOVED, 0, nil) *
        500
end

function cm.atkfilter(c)
    return aux.IsCodeListed(c, yr) and c:IsType(TYPE_EQUIP)
end
