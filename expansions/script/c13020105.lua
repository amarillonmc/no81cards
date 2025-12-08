--跳出三界外
local cm, m, o = GetID()
function cm.initial_effect(c)
    -- 自由时点效果：从手牌丢弃触发空白效果
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(cm.discardcost)
    e1:SetTarget(cm.discardtg)
    e1:SetOperation(cm.discardop)
    c:RegisterEffect(e1)
end

-- 丢弃触发条件
function cm.discardcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
end

-- 丢弃触发目标
-- 丢弃cost
function cm.discardcost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
end

-- 丢弃触发目标
function cm.discardtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
end

-- 丢弃触发操作
function cm.discardop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    -- 下回合准备阶段触发的永续效果
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START + PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCountLimit(1)
    e2:SetOperation(cm.prepop)
    Duel.RegisterEffect(e2, tp)
    --
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_ADJUST)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetLabelObject(e2)
    e4:SetReset(RESET_PHASE + PHASE_END)
    e4:SetOperation(cm.setop)
    Duel.RegisterEffect(e4, tp)
end

function cm.setop(e, tp, eg, ep, ev, re, r, rp)
    local e2 = e:GetLabelObject()
    local label = { e2:GetLabel() }
    local eta = { EFFECT_CANNOT_SPECIAL_SUMMON, EFFECT_CANNOT_ACTIVATE }

    for n, mi in pairs(eta) do
        local et = { Duel.IsPlayerAffectedByEffect(tp, mi) }
        if et[1] ~= nil then
            for n, ni in pairs(et) do
                if ni ~= nil then
                    ni:Reset()
                    local ec = ni:GetOwner()
                    for i = 1, 0xfff, 1 do
                        -- local digits = 0
                        -- local tmp = i
                        -- while tmp > 0 do
                        --     tmp = math.floor(tmp / 10)
                        --     digits = digits + 1
                        -- end
                        if ec:IsSetCard(i) then
                            label[#label + 1] = i
                        end
                    end
                end
            end
        end
    end
    e2:SetLabel(table.unpack(label))
end

-- 准备阶段触发操作
function cm.prepop(e, tp, eg, ep, ev, re, r, rp)
    local label = { e:GetLabel() }
    if label[1] == 0 then table.remove(label, 1) end
    if label[1] ~= 0 then
        -- 从自己卡组把1张字段在label内的卡加入手卡
        local g = Duel.GetMatchingGroup(nil, tp, LOCATION_DECK, 0, nil)
        local sg = Group.CreateGroup()

        -- 遍历卡组中的卡，检查是否属于label中的字段
        for tc in aux.Next(g) do
            for _, setcode in ipairs(label) do
                if tc:IsSetCard(setcode) then
                    sg:AddCard(tc)
                    break
                end
            end
        end

        if #sg > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
            local tg = sg:Select(tp, 1, 1, nil)
            if #tg > 0 then
                Duel.SendtoHand(tg, nil, REASON_EFFECT)
                Duel.ConfirmCards(1 - tp, tg)
            end
        end
    end
    e:Reset()
end
