--白露未已
local cm, m, o = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end, function() dofile("script/c16670000.lua") end)
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCountLimit(1, m)
    e2:SetCondition(cm.condition)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)

    local e11 = Effect.CreateEffect(c)
    -- e11:SetDescription(aux.Stringid(m, 0))
    e11:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e11:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e11:SetProperty(EFFECT_FLAG_DELAY)
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    e11:SetCost(cm.cost)
    e11:SetTarget(cm.drtg)
    e11:SetOperation(cm.drop)
    c:RegisterEffect(e11)

    if not cm.global_check then
        cm.global_check = true
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
        e4:SetCode(EVENT_ADJUST)
        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
        e4:SetOperation(cm.adop)
        Duel.RegisterEffect(e4, tp)
    end
end

function cm.cfilter(c, e, tp, sc)
    return c:IsAbleToDeckAsCost() and aux.IsCodeListed(c, yr) and (c:IsLocation(QY_sk) or
        Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0)
end

function cm.cfilter2(c, e, tp, sc)
    return c:IsAbleToExtraAsCost() and Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0
end

function cm.condition(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = Duel.GetMatchingGroup(cm.cfilter, tp, LOCATION_HAND + LOCATION_ONFIELD, 0, nil, e, tp, c)
    local g2 = Duel.GetMatchingGroup(cm.cfilter2, tp, LOCATION_ONFIELD, 0, nil, e, tp, c)
    return #g > 0 and #g2 > 0
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    local g1 = Duel.SelectMatchingCard(tp, cm.cfilter, tp, LOCATION_HAND + LOCATION_ONFIELD, 0, 1, 1, nil, e, tp, c)
    local g2 = Duel.SelectMatchingCard(tp, cm.cfilter2, tp, LOCATION_ONFIELD, 0, 1, 1, g1, e, tp, c)
    g2:Merge(g1)
    c:SetMaterial(g2)
    Duel.SendtoDeck(g2, tp, SEQ_DECKSHUFFLE, REASON_COST + REASON_MATERIAL)
end

function cm.cfilter3(c, e, tp, sc)
    return (c:IsAbleToRemove() or c:IsAbleToGrave()) and aux.IsCodeListed(c, yr)
end

function cm.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    local g = Duel.GetMatchingGroup(cm.cfilter3, tp, QY_kz, 0, nil)
    if chk == 0 then return #g > 0 end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    if #g == 0 then return end
    local sg = g:Select(tp, 1, 1, nil):GetFirst()
    local off = 1
    local ops = {}
    local opval = {}
    if sg:IsAbleToRemove() then
        ops[off] = aux.Stringid(m, 0)
        opval[off - 1] = 1
        off = off + 1
    end
    if sg:IsAbleToGrave() then
        ops[off] = aux.Stringid(m, 1)
        opval[off - 1] = 2
        off = off + 1
    end
    local op = Duel.SelectOption(tp, table.unpack(ops))
    if opval[op] == 1 then
        Duel.SendtoGrave(sg, REASON_EFFECT)
    elseif opval[op] == 2 then
        Duel.Remove(sg, POS_FACEUP, REASON_EFFECT)
    end
    e:SetLabel(sg:GetCode())
end

function cm.cfilter4(c, code)
    return c:IsAbleToHand() and aux.IsCodeListed(c, yr) and not c:IsCode(code)
end

function cm.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local code = e:GetLabel()
    local g = Duel.GetMatchingGroup(cm.cfilter4, tp, QY_kz + QY_md + QY_cw, 0, nil, code)
    if chk == 0 then return #g > 0 end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, QY_kz + QY_md + QY_cw)
end

function cm.drop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local code = e:GetLabel()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    local g = Duel.GetMatchingGroup(cm.cfilter4, tp, QY_kz + QY_md + QY_cw, 0, nil, code)
    local sg = g:Select(tp, 1, 1, nil)
    Duel.SendtoHand(sg, tp, REASON_EFFECT)
    if Duel.SelectYesNo(tp, aux.Stringid(m, 2)) then
        local g = Duel.GetFieldGroup(tp, LOCATION_HAND, 0):Select(tp, 1, 1, nil)
        if g:GetCount() > 0 then
            Duel.BreakEffect()
            if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) ~= 0 then
                Duel.RegisterFlagEffect(tp, m, RESET_PHASE + PHASE_END, 0, 2)
            end
        end
    end
end

function cm.adop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ng = Duel.GetMatchingGroup(cm.filsn, tp, LOCATION_HAND + LOCATION_ONFIELD + LOCATION_GRAVE + QY_kz, 0, nil)
    local nc = ng:GetFirst()
    while nc do
        if not cm.reg then
            cm.reg = Card.RegisterEffect
            Card.RegisterEffect = cm.reg2
        end
        nc:RegisterFlagEffect(m, 0, 0, 1)
        nc:ReplaceEffect(nc:GetOriginalCodeRule(), 0)
        nc = ng:GetNext()
    end
end

function cm.filsn(c)
    return aux.IsCodeListed(c, yr) and c:GetFlagEffect(m) == 0
end

function cm.reg2(c, ie, ob)
    local b = ob or false
    local p = ie:GetCode()
    local id, ida = ie:GetCountLimit()
    if not aux.IsCodeListed(c, yr) and (not ie:IsActivated() or not id or not ida) or
        bit.band(ie:GetProperty(), EFFECT_FLAG_CARD_TARGET) == 0 then
        return cm.reg(c, ie, b)
    end
    -- Debug.Message(id, ida)
    local co = ie:GetCondition()
    local ie2 = ie:Clone()
    if id or ida then
        ie2:SetCountLimit(id + 1, ida)
    end
    ie2:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local code = Duel.GetFlagEffect(tp, m)
        return (not co or co(e, tp, eg, ep, ev, re, r, rp)) and code > 0
    end)
    if bit.band(ie2:GetProperty(), EFFECT_FLAG_CARD_TARGET) ~= 0 then
        local tn = ie:GetTarget()
        ie2:SetProperty(ie2:GetProperty() - EFFECT_FLAG_CARD_TARGET)
        ie2:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
            local exis = Duel.IsExistingTarget
            local exis2 = Duel.SelectTarget
            local operat = Duel.SetOperationInfo
            Duel.IsExistingTarget = function(fun, tp2, s1, o1, num, cg, ...)
                -- cm[ie2] = { tp, fun, tp2, s1, o1, num, cg, ... }
                return Duel.IsExistingMatchingCard(fun, tp2, s1, o1, num, cg, ...)
            end
            Duel.SelectTarget = function(tp1, fun, tp2, s1, o1, min, max, cg, ...)
                local t = { ... }
                for _, va in ipairs(t) do
                    if aux.GetValueType(va) == "Group" then
                        Group.KeepAlive(va)
                    end
                end
                cm[ie2] = { tp1, fun, tp2, s1, o1, min, max, cg, { ... } }
                -- Duel.ConfirmCards(tp, table.unpack({ ... }))
                return Group.CreateGroup()
            end
            Duel.SetOperationInfo = function(chainc, category, targets, count, target_player, target_param)
                return operat(chainc, category, nil, count, target_player, target_param)
            end
            local jg = tn(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
            Duel.IsExistingTarget = exis
            Duel.SelectTarget = exis2
            Duel.SetOperationInfo = operat

            return jg
        end)
        local op = ie:GetOperation()
        ie2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
            local ma = cm[ie2]
            -- Debug.Message(ma[0])
            -- Debug.Message(ma[1])
            -- Debug.Message(ma[2])
            -- Debug.Message(ma[3])
            -- Debug.Message(ma[4])
            -- Debug.Message(ma[5])
            -- Debug.Message(ma[6])
            -- Debug.Message(table.unpack(ma[8]))
            -- Duel.ConfirmCards(tp, table.unpack(ma[9]))
            local g = Duel.SelectMatchingCard(ma[1], ma[2], ma[3], ma[4], ma[5], ma[6], ma[7], ma[8],
                table.unpack(ma[9]))
            --ma[0], ma[1], ma[2], ma[3], ma[4], 1, ma[5],ma[6], table.unpack(ma[7])
            -- local g = Group.CreateGroup()
            local xta = Duel.GetFirstTarget
            Duel.GetFirstTarget = function() return g:GetFirst(), g:GetNext(), g:GetNext(), g:GetNext() end
            for tc in aux.Next(g) do
                tc:CreateEffectRelation(e)
            end
            op(e, tp, eg, ep, ev, re, r, rp)
            Duel.GetFirstTarget = xta
        end)
    end
    ie:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local code = Duel.GetFlagEffect(tp, m)
        return (not co or co(e, tp, eg, ep, ev, re, r, rp)) and code == 0
    end)
    return cm.reg(c, ie, b), cm.reg(c, ie2, b)
end
