-- 诅咒玩偶
local cm, m = GetID()
function cm.initial_effect(c)
    if not cm.gall then
        cm.gall = true
        cm.global_jc = {}
        --
        local l = Effect.IsHasType
        Effect.IsHasType = function(ea, le)
            if ea:GetLabel() == m then return true end
            for z, v in pairs(cm.global_jc) do
                for i = 1, #v do
                    if v[i] == ea and le == EFFECT_TYPE_ACTIVATE then
                        return true
                    end
                end
            end
            return l(ea, le)
        end
        local l2 = Card.GetActivateEffect
        Card.GetActivateEffect = function(card)
            local ob = { l2(card) }
            for z, v in pairs(cm.global_jc) do --表名，表内容
                if z == card then
                    for i = 1, #v do
                        ob[#ob + 1] = v[i]
                    end
                end
            end
            return table.unpack(ob)
        end
        local l3 = Effect.Clone
        Effect.Clone = function(ea)
            local qe = l3(ea)
            if ea:GetLabel() == m then
                -- 这里不需要操作global_jc，因为原来的逻辑有问题
                return qe
            end
            for z, v in pairs(cm.global_jc) do
                for i = 1, #v do
                    if v[i] == ea then
                        cm.global_jc[z][#cm.global_jc[z] + 1] = qe
                        return qe
                    end
                end
            end
            return qe
        end
        --模拟魔法
        local ge13 = Effect.CreateEffect(c)
        ge13:SetType(EFFECT_TYPE_FIELD)
        ge13:SetCode(EFFECT_ACTIVATE_COST)
        ge13:SetTargetRange(1, 1)
        ge13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        ge13:SetTarget(cm.actarget)
        ge13:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge13, 0)
    end
    -- 基本装备效果
    local e0 = aux.AddEquipSpellEffect(c, true, true, Card.IsFaceup, nil)
    local qe = e0:Clone()
    local de = e0:GetDescription()
    if not de then
        qe:SetDescription(aux.Stringid(m, 1))
    end
    qe:SetType(EFFECT_TYPE_QUICK_O)
    qe:SetCode(EVENT_FREE_CHAIN)
    qe:SetRange(LOCATION_HAND)
    local con = e0:GetCondition()
    qe:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return not Duel.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) and
            (not con or con(e, tp, eg, ep, ev, re, r, rp))
    end)
    -- 修复未定义的tc变量
    cm.global_jc[c] = cm.global_jc[c] or {}
    cm.global_jc[c][#cm.global_jc[c] + 1] = qe
    c:RegisterEffect(qe)

    e0:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return Duel.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) and
            (not con or con(e, tp, eg, ep, ev, re, r, rp))
    end)

    -- 效果1：装备怪兽不能成为连接•同调•融合•超量素材
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e2)
    local e3 = e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e3)
    local e4 = e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e4)
    -- 效果2：怪兽召唤•特殊召唤的场合发动
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m, 0))
    e5:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(cm.triggercon)
    e5:SetTarget(cm.triggertg)
    e5:SetOperation(cm.triggerop)
    c:RegisterEffect(e5)
    local e6 = e5:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
end

function cm.triggercon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ec = c:GetEquipTarget()
    return ec ~= nil
end

function cm.triggertg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    -- 仅在装备怪兽攻击力为0时才会触发后续操作，所以这里添加条件判断
    local c = e:GetHandler()
    if ec and (ec:GetAttack() - 444) == 0 then
        Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, c, 1, 0, 0)
    end
end

function cm.triggerop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ec = c:GetEquipTarget()
    if not ec or not c:IsRelateToEffect(e) then return end

    -- 装备怪兽攻击力下降444
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-444)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
    ec:RegisterEffect(e1)

    -- 攻击力为0的场合，从卡组选1张「诅咒玩偶」以外的装备魔法卡加入手卡
    local addedCards = 0
    if ec:GetAttack() == 0 then
        local g = Duel.GetMatchingGroup(cm.filter, tp, LOCATION_DECK, 0, nil)
        if #g > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
            local sg = g:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.SendtoHand(sg, nil, REASON_EFFECT)
                Duel.ConfirmCards(1 - tp, sg)
                addedCards = #sg
            end
        end
        c:RegisterFlagEffect(m + 1, RESET_EVENT + RESETS_STANDARD, 0, 1)
        local num = 748 * c:GetFlagEffect(m + 1)
        local e12 = Effect.CreateEffect(c)
        e12:SetType(EFFECT_TYPE_SINGLE)
        e12:SetCode(EFFECT_UPDATE_ATTACK)
        e12:SetValue(num)
        e12:SetReset(RESET_EVENT + RESETS_STANDARD)
        ec:RegisterEffect(e12)
        if Duel.SelectYesNo(tp, aux.Stringid(m, 4)) then
            Duel.Destroy(c, REASON_EFFECT)
        end
        -- 那之后，装备怪兽解放，或者作为代替让这张卡破坏
        -- local b1 = ec:IsReleasable()
        -- local b2 = c:IsDestructable(e)
        -- if b1 or b2 then
        --     local opt = 0
        --     if b1 and b2 then
        --         opt = Duel.SelectOption(tp, aux.Stringid(m, 2), aux.Stringid(m, 3))
        --     elseif b1 then
        --         opt = 0
        --     else
        --         opt = 1
        --     end

        --     if opt == 0 then
        --         Duel.Release(ec, REASON_EFFECT)
        --     else
        --         Duel.Destroy(c, REASON_EFFECT)
        --     end
        -- end
    end
end

function cm.filter(c)
    return c:IsType(TYPE_EQUIP) and not c:IsCode(m) and c:IsAbleToHand()
end

function cm.actarget(e, te, tp)
    local c = te:GetHandler()
    local e1 = e:GetLabelObject()
    if te:GetLabel() == m then return true end
    for z, v in pairs(cm.global_jc) do
        for i = 1, #v do
            if v[i] == te then
                e:SetLabelObject(z)
                return true
            end
        end
    end
    return false
end

function cm.checkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetLabelObject()
    tp = c:GetControler()
    cm.checkopn(e, tp, c)
end

function cm.checkopn(e, tp, c, mf)
    --
    if c:IsLocation(LOCATION_HAND) then
        if not c:IsType(TYPE_FIELD) then
            Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
        else
            local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
            if fc then
                Duel.SendtoGrave(fc, REASON_RULE)
                Duel.BreakEffect()
            end
            Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
        end
        if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and not c:IsType(TYPE_EQUIP) then c:CancelToGrave(false) end
    end
    if c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_FIELD) then
        local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
        if fc then
            Duel.SendtoGrave(fc, REASON_RULE)
            Duel.BreakEffect()
        end
        local ta = Duel.GetMatchingGroup(aux.TRUE, tp, 0xfff - LOCATION_MZONE, 0xfff - LOCATION_MZONE, nil)
        local tc = ta:GetFirst()
        if tc then
            Duel.Overlay(tc, c)
        end
        Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
    end
    Duel.ChangePosition(c, POS_FACEUP)

    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_END)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and
            (not c:IsType(TYPE_EQUIP) or (c:IsType(TYPE_EQUIP) and not c:GetEquipTarget())) and c:IsLocation(LOCATION_SZONE) and c:IsHasEffect(EFFECT_REMAIN_FIELD) == nil then
            Duel.SendtoGrave(c, REASON_RULE)
        end
        e:Reset()
    end)
    Duel.RegisterEffect(e1, 0)
end
