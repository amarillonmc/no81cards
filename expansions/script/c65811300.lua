-- 狂野征服斗魂 不灭的虚像
local s, id = GetID()
function s.initial_effect(c)
    -- 仅允许其自身ID触发，防止影响其他卡
    if c:GetOriginalCodeRule() == id then
        -- 判定是否为决斗刚开始的时刻
        local ct = Duel.GetFieldGroupCount(0, 0, LOCATION_DECK)
        local ct2 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
        local tp = 0
        if ct > 0 or ct2 > 0 then tp = 1 end
        if s[tp] and s[tp] == 1 then return end
        s[tp] = 1

        -- 挂载开局的调整触发器
        local e01 = Effect.CreateEffect(c)
        e01:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e01:SetCode(EVENT_ADJUST)
        e01:SetOperation(s.adjustop)
        Duel.RegisterEffect(e01, 0)
        local e02 = e01:Clone()
        Duel.RegisterEffect(e02, 1)
    end
end

function s.cfilter1(c)
	return c:IsSetCard(0x195) and c:IsLocation(LOCATION_DECK)
end

-- =========================================================================
-- 通常魔法 变 二速手坑 核心拦截器
-- =========================================================================
function s.actarget2(e, te, tp)
    local tc = te:GetHandler()
    e:SetLabelObject(te)
    -- 拦截从手卡发动的、二速的、VS字段的非速攻魔法卡
    return tc:IsSetCard(0x195) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL) and not tc:IsType(TYPE_QUICKPLAY)
end

function s.costop(e, tp, eg, ep, ev, re, r, rp)
    local te = e:GetLabelObject()
    local tc = te:GetHandler()
    local te2 = te:Clone()
    tc:RegisterEffect(te2)
    te2:UseCountLimit(tp)
    -- 发动瞬间强行转化为 ACTIVATE
    te:SetType(EFFECT_TYPE_ACTIVATE)
    
    -- 物理搬运到场上
    if tc:IsType(TYPE_FIELD) then
        local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
        if fc then
            Duel.SendtoGrave(fc, REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc, tp, tp, LOCATION_FZONE, POS_FACEUP, false)
    else
        Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, false)
    end
    
    -- 埋下连锁处理后的清除任务
    local ge3 = Effect.CreateEffect(tc)
    ge3:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    ge3:SetCode(EVENT_CHAIN_SOLVED)
    ge3:SetLabelObject(te)
    ge3:SetReset(RESET_PHASE + PHASE_END)
    ge3:SetOperation(s.resetop)
    Duel.RegisterEffect(ge3, tp)
    
    local ge4 = ge3:Clone()
    ge4:SetCode(EVENT_CHAIN_NEGATED)
    Duel.RegisterEffect(ge4, tp)
end

function s.resetop(e, tp, eg, ep, ev, re, r, rp)
    -- 处理完毕后，抹除掉伪装的效应，防止系统崩坏
    if re == e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
        e:Reset()
        re:Reset()
    end
end
-- =========================================================================

function s.adjustop(e, tp, eg, ep, ev, re, r, rp)
    if s.globle_check then return end
    s.globle_check = true
    
    local c = e:GetOwner()
    
    -- ①：决斗开始时，把额外卡组的这张卡给对方观看
    Duel.ConfirmCards(1-tp, c)
    Duel.Hint(HINT_CARD, 0, id)

    -- 初始化用来还原“展示后洗回卡组”的全局数据结构
    VS_Hand_Table = {}
    VS_Deck_To_Hand_Group = Group.CreateGroup()
    VS_Deck_To_Hand_Group:KeepAlive()

    -- 挂载全局的发动Cost拦截器 (北极天熊机制)
    local ge1 = Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD)
    ge1:SetCode(EFFECT_ACTIVATE_COST)
    ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE)
    ge1:SetTargetRange(1, 0)
    ge1:SetTarget(s.actarget2)
    ge1:SetOperation(s.costop)
    Duel.RegisterEffect(ge1, 0)
    local ge2 = ge1:Clone()
    Duel.RegisterEffect(ge2, 1)

    -- --------------------------------------------------------
    -- 核心黑魔法区：底层引擎 C++ 函数劫持 (Hooking)
    -- --------------------------------------------------------

    -- 1. 欺骗 Public 判定：让 VS 允许选择已经公开的卡作为代价
    local _IsPublic = Card.IsPublic
    Card.IsPublic = function(card)
        if VS_Cost_Flag or VS_Target_Flag or VS_Condition_Flag then return false end
        return _IsPublic(card)
    end

    -- 2. 欺骗 Location 判定：解决连锁结束后卡回卡组，但在诱发条件判断中仍需要视作在手卡的问题
    local _IsLocation = Card.IsLocation
    Card.IsLocation = function(card, loc)
        if VS_Condition_Flag and loc == LOCATION_HAND and VS_Hand_Table[card] then
            return true
        end
        return _IsLocation(card, loc)
    end

    -- 3. 欺骗寻卡引擎：让原版只能寻找手卡的代码，在 VS 执行时把卡组也纳入搜索雷达
    local _GetMatchingGroup = Duel.GetMatchingGroup
    Duel.GetMatchingGroup = function(filter, tp, loc1, loc2, ex, ...)
        local l1, l2 = loc1, loc2
        if (VS_Cost_Flag or VS_Target_Flag or VS_Condition_Flag) and loc1 == LOCATION_HAND and loc2 == 0 then
            l1 = LOCATION_HAND + LOCATION_DECK
        end
        return _GetMatchingGroup(filter, tp, l1, l2, ex, ...)
    end

    local _IsExistingMatchingCard = Duel.IsExistingMatchingCard
    Duel.IsExistingMatchingCard = function(filter, tp, loc1, loc2, count, ex, ...)
        local l1, l2 = loc1, loc2
        if (VS_Cost_Flag or VS_Target_Flag or VS_Condition_Flag) and loc1 == LOCATION_HAND and loc2 == 0 then
            l1 = LOCATION_HAND + LOCATION_DECK
        end
        return _IsExistingMatchingCard(filter, tp, l1, l2, count, ex, ...)
    end

    -- 4. 劫持点选函数：一旦玩家从卡组选了卡，立刻加入手卡并提供持续公开提示
    local _SelectMatchingCard = Duel.SelectMatchingCard
    Duel.SelectMatchingCard = function(tp, filter, sel_tp, loc1, loc2, min, max, ex, ...)
        local l1, l2 = loc1, loc2
        if VS_Cost_Flag and loc1 == LOCATION_HAND and loc2 == 0 then
            l1 = LOCATION_HAND + LOCATION_DECK
        end
        local g = _SelectMatchingCard(tp, filter, sel_tp, l1, l2, min, max, ex, ...)
        if VS_Cost_Flag and g and #g > 0 then
            local dg = g:Filter(s.cfilter1, nil)
            if #dg > 0 then
                Duel.SendtoHand(dg, nil, REASON_EFFECT)
                for tc in aux.Next(dg) do
                    VS_Hand_Table[tc] = true -- 记录到此回合的代理表
                    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD, 0, 1)
                    local e1=Effect.CreateEffect(c)
                    e1:SetDescription(aux.Stringid(id,0))
	                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
                    tc:RegisterEffect(e1)
                end
                VS_Deck_To_Hand_Group:Merge(dg)
            end
        end
        return g
    end

    local _SelectSubGroup = Group.SelectSubGroup
    Group.SelectSubGroup = function(g, tp, f, cancel, min, max, ...)
        local res = _SelectSubGroup(g, tp, f, cancel, min, max, ...)
        if VS_Cost_Flag and res and #res > 0 then
            local dg = res:Filter(s.cfilter1, nil)
            if #dg > 0 then
                Duel.SendtoHand(dg, nil, REASON_EFFECT)
                for tc in aux.Next(dg) do
                    VS_Hand_Table[tc] = true
                    tc:RegisterFlagEffect(id, RESET_EVENT+RESETS_STANDARD, 0, 1)
                    local e1=Effect.CreateEffect(c)
                    e1:SetDescription(aux.Stringid(id,0))
	                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
                    tc:RegisterEffect(e1)
                end
                VS_Deck_To_Hand_Group:Merge(dg)
            end
        end
        return res
    end

    -- --------------------------------------------------------
    -- 原版「征服斗魂」全卡重构加载区
    -- --------------------------------------------------------
    local g = Duel.GetMatchingGroup(function(card) return card:IsSetCard(0x195) and not card:IsCode(id) end, 0, 0xff, 0xff, nil)
    
    local cregister = Card.RegisterEffect
    local ecreateeffect = Effect.CreateEffect
    local esetcountLimit = Effect.SetCountLimit

    table_effect = {}
    table_countlimit_flag = 0
    table_countlimit_count = 0
    VS_Creating = false

    Effect.CreateEffect = function(card)
        VS_Creating = true
        return ecreateeffect(card)
    end
    
    Effect.SetCountLimit = function(effect, count, flag)
        -- 这里负责拦截原卡的誓约和一回合同名卡限制
        if not VS_Creating and count == 1 and flag ~= nil and flag ~= 0 then
            local eff = table_effect[#table_effect]
            if eff then return esetcountLimit(eff, 1, 0) end
        end
        table_countlimit_flag = flag or 0
        table_countlimit_count = count or 0
        return esetcountLimit(effect, count, flag)
    end

    Card.RegisterEffect = function(card, effect, flag)
        if effect then
            local eff = effect:Clone()
            local con = eff:GetCondition()
            local cos = eff:GetCost()
            local tg = eff:GetTarget()

            if card:IsSetCard(0x195) then
                -- 核心解除限制：若原本是 1回合1张(带ID的誓约)，直接剥除ID限制
                if table_countlimit_flag ~= 0 and table_countlimit_count == 1 then
                    esetcountLimit(eff, 1, 0)
                end

                -- 为非速攻的魔法卡，额外追加一个“二速手坑版”的影子效果
                if eff:IsHasType(EFFECT_TYPE_ACTIVATE) and card:IsType(TYPE_SPELL) and not card:IsType(TYPE_QUICKPLAY) then
                    local eff_hand = eff:Clone()
                    eff_hand:SetType(EFFECT_TYPE_QUICK_O)
                    eff_hand:SetCode(EVENT_FREE_CHAIN)
                    eff_hand:SetRange(LOCATION_HAND)
                    eff_hand:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER, TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
                    
                    local con_h = eff_hand:GetCondition()
                    eff_hand:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
                        VS_Condition_Flag = true
                        local _IsMainPhase = Duel.IsMainPhase
                        local _GetCurrentPhase = Duel.GetCurrentPhase
                        Duel.IsMainPhase = function() return true end
                        Duel.GetCurrentPhase = function() return PHASE_MAIN1 end
                        local res = not con_h or con_h(e, tp, eg, ep, ev, re, r, rp)
                        Duel.IsMainPhase = _IsMainPhase
                        Duel.GetCurrentPhase = _GetCurrentPhase
                        VS_Condition_Flag = false
                        return res
                    end)
                    
                    local cos_h = eff_hand:GetCost()
                    if cos_h then
                        eff_hand:SetCost(function(e, tp, eg, ep, ev, re, r, rp, chk)
                            VS_Cost_Flag = true
                            local res = cos_h(e, tp, eg, ep, ev, re, r, rp, chk)
                            VS_Cost_Flag = false
                            return res
                        end)
                    end
                    
                    local tg_h = eff_hand:GetTarget()
                    if tg_h then
                        eff_hand:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
                            VS_Target_Flag = true
                            local _GetFlagEffect = Duel.GetFlagEffect
                            Duel.GetFlagEffect = function(p, code)
                                if code == card:GetOriginalCode() then return 0 end
                                return _GetFlagEffect(p, code)
                            end
                            local res = tg_h(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
                            Duel.GetFlagEffect = _GetFlagEffect
                            VS_Target_Flag = false
                            return res
                        end)
                    end
                    table.insert(table_effect, eff_hand)
                end

                -- 将主阶段效果改为 对方回合也能发动的二速效果，同时挂上 Condition 代理标签
                if con and eff:IsHasType(EFFECT_TYPE_QUICK_O) and eff:GetCode() == EVENT_FREE_CHAIN then
                    eff:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
                        VS_Condition_Flag = true
                        local _IsMainPhase = Duel.IsMainPhase
                        local _GetCurrentPhase = Duel.GetCurrentPhase
                        Duel.IsMainPhase = function() return true end
                        Duel.GetCurrentPhase = function() return PHASE_MAIN1 end
                        local res = con(e, tp, eg, ep, ev, re, r, rp)
                        Duel.IsMainPhase = _IsMainPhase
                        Duel.GetCurrentPhase = _GetCurrentPhase
                        VS_Condition_Flag = false
                        return res
                    end)
                    eff:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER, TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
                elseif eff:IsHasType(EFFECT_TYPE_IGNITION) then
                    eff:SetType(EFFECT_TYPE_QUICK_O)
                    eff:SetCode(EVENT_FREE_CHAIN)
                    eff:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER, TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
                    if con then
                        eff:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
                            VS_Condition_Flag = true
                            local _IsMainPhase = Duel.IsMainPhase
                            local _GetCurrentPhase = Duel.GetCurrentPhase
                            Duel.IsMainPhase = function() return true end
                            Duel.GetCurrentPhase = function() return PHASE_MAIN1 end
                            local res = con(e, tp, eg, ep, ev, re, r, rp)
                            Duel.IsMainPhase = _IsMainPhase
                            Duel.GetCurrentPhase = _GetCurrentPhase
                            VS_Condition_Flag = false
                            return res
                        end)
                    else
                        eff:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
                            VS_Condition_Flag = true
                            local res = true
                            VS_Condition_Flag = false
                            return res
                        end)
                    end
                end
                
                -- 若原本没有被上方的阶段欺骗包裹，则独立挂上 Condition 代理标签
                if eff:GetCondition() == con and con then
                    eff:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
                        VS_Condition_Flag = true
                        local res = con(e, tp, eg, ep, ev, re, r, rp)
                        VS_Condition_Flag = false
                        return res
                    end)
                end

                -- 包裹 Cost 与 Target，确保判定雷达扩充至卡组
                if cos then
                    eff:SetCost(function(e, tp, eg, ep, ev, re, r, rp, chk)
                        VS_Cost_Flag = true
                        local res = cos(e, tp, eg, ep, ev, re, r, rp, chk)
                        VS_Cost_Flag = false
                        return res
                    end)
                end
                
                -- 黑魔法：抹除“同一连锁上不能发动”
                if tg then
                    eff:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
                        VS_Target_Flag = true
                        
                        -- 拦截底层 Flag 查询函数
                        local _GetFlagEffect = Duel.GetFlagEffect
                        Duel.GetFlagEffect = function(p, code)
                            -- OCG是用怪兽的自身ID注册防同一连锁的，因此查询自身ID时我们谎报为0
                            if code == card:GetOriginalCode() then return 0 end
                            return _GetFlagEffect(p, code)
                        end
                        
                        local res = tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
                        
                        -- 还原底层查询函数
                        Duel.GetFlagEffect = _GetFlagEffect
                        VS_Target_Flag = false
                        return res
                    end)
                end
            end
            
            table.insert(table_effect, eff)
        end
        table_countlimit_flag = 0
        table_countlimit_count = 0
        VS_Creating = false
        return 
    end

    for tc in aux.Next(g) do
        table_effect = {}
        -- 抹去卡片原本代码，防止原效果与我们注入的代理起冲突
        tc:ReplaceEffect(id, 0)
        
        -- 调用底层神技：重新初始化该卡，触发我们的劫持
        Duel.CreateToken(0, tc:GetOriginalCode())
        for key, eff in ipairs(table_effect) do
            cregister(tc, eff)
        end
        
        -- 对速攻和陷阱单独赋予手卡发动权限（通常魔法已走北极天熊拦截路径，不需要此项）
        if tc:IsType(TYPE_SPELL+TYPE_TRAP) and (tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)) then
            local e1 = ecreateeffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
            cregister(tc, e1)
            local e2 = e1:Clone()
            e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
            cregister(tc, e2)
        end
    end

    -- 还原三大函数
    Card.RegisterEffect = cregister
    Effect.CreateEffect = ecreateeffect
    Effect.SetCountLimit = esetcountLimit

    -- --------------------------------------------------------
    -- 裁定实现：连锁结束时回卡组
    -- --------------------------------------------------------
    local ge1 = Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_CHAIN_END)
    ge1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        if VS_Deck_To_Hand_Group and #VS_Deck_To_Hand_Group > 0 then
            -- 筛选出那些拥有标记，且仍然在手卡的牌
            local tg = VS_Deck_To_Hand_Group:Filter(function(card) return card:GetFlagEffect(id) > 0 and card:IsLocation(LOCATION_HAND) end, nil)
            if #tg > 0 then
                Duel.SendtoDeck(tg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
            end
            VS_Deck_To_Hand_Group:Clear()
        end
    end)
    Duel.RegisterEffect(ge1, 0)

    -- 回合结束时清空记录表，防止越积越多引发混乱
    local ge2 = Effect.CreateEffect(c)
    ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_PHASE + PHASE_END)
    ge2:SetCountLimit(1)
    ge2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        VS_Hand_Table = {}
    end)
    Duel.RegisterEffect(ge2, 0)

    -- 执行完毕后销毁自身（`EVENT_ADJUST`），防止无限次读取重置
    e:Reset()
end