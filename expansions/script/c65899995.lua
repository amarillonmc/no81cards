-- 聚集之星的牵绊
local s, id = GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	--aux.AddCodeList(c,20007374,24696097,44508094,30983281,60800381,50091196,75874514,11069680,63436931,9012916,25862681,73580471,70902743,47264717,25165047)
    -- 开局转化及规则挂载
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE_START + PHASE_DRAW)
    e1:SetRange(0xff)
    e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_DUEL)
    e1:SetOperation(s.chop)
    c:RegisterEffect(e1)
end

function s.check(c)
    return c:GetOriginalCode() == id
end

function s.chop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local cg = Duel.GetMatchingGroup(s.check, tp, 0xff, 0, nil)
    
    -- 防止卡组复数投入产生混乱，统统变身为《聚集的祈愿》
    if #cg >= 1 then
        for tc in aux.Next(cg) do
            if KOISHI_CHECK then 
                tc:SetEntityCode(20007374) 
                tc:ReplaceEffect(tc:GetOriginalCode(),0,0)
            else 
                local loc=tc:GetLocation()
                Duel.Remove(tc,POS_FACEDOWN,REASON_RULE) 
                if loc==LOCATION_DECK then 
                    local t_meteor = Duel.CreateToken(tp, 20007374) 
                    Duel.SendtoDeck(t_meteor,tp,SEQ_DECKSHUFFLE,REASON_RULE)
                end
                if loc==LOCATION_HAND then 
                    local t_meteor = Duel.CreateToken(tp, 20007374) 
                    Duel.SendtoHand(t_meteor, nil, REASON_RULE)
                    Duel.ShuffleHand(tp)
                end
            end
            if not tc:IsLocation(LOCATION_HAND) then 
                Duel.ConfirmCards(tp, tc) 
            end
        end
    end
    
    Duel.Hint(HINT_CARD, 0, id)
    
    -- 1. 从游戏外把 5 只大怪加入额外卡组
    local ex_codes = {24696097, 44508094, 30983281, 60800381, 50091196}
    local ex_g = Group.CreateGroup()
    for _, code in ipairs(ex_codes) do
        local token = Duel.CreateToken(tp, code)
        ex_g:AddCard(token)
    end
    Duel.SendtoDeck(ex_g, nil, SEQ_DECKBOTTOM, REASON_RULE)
    
    -- 2. 限制本局决斗不能特召特定怪兽之外的怪兽
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetTargetRange(1, 0)
    e0:SetTarget(s.splimit)
    Duel.RegisterEffect(e0, tp)
    
    -- 3. 自己对「聚集的祈愿」的发动从手卡也能用
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetTargetRange(LOCATION_HAND, 0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule, 20007374))
    Duel.RegisterEffect(e1, tp)

    -- 4. 挂载主要阶段选项效果 1（洗2手卡，派2星尘，拿流星，埋转换者和方程式）
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(s.op1_con)
    e2:SetOperation(s.op1_op)
    Duel.RegisterEffect(e2, tp)

    -- 5. 挂载主要阶段选项效果 2（派5龙）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(s.op2_con)
    e3:SetOperation(s.op2_op)
    Duel.RegisterEffect(e3, tp)

    -- 防御卡组数量限制崩溃
     if KOISHI_CHECK then
        c:SetEntityCode(20007374)
        if Duel.GetMatchingGroupCount(Card.IsOriginalCodeRule, tp, 0xff, 0, nil, 20007374) > 3 then    
            Duel.Hint(24,0,aux.Stringid(id,5))
            Duel.Win(1-tp, 0xa32)
        end
    else
        if Duel.GetMatchingGroupCount(Card.IsOriginalCodeRule, tp, 0xff, 0, nil, 20007374) > 3 then    
            Duel.Hint(24,0,aux.Stringid(id,5))
            Duel.Win(1-tp, 0xa32)
        end
    end
end
---------------------------------------------------------------------
-- 誓约限制
---------------------------------------------------------------------
function s.splimit(e, c)
    -- 可以特召：
    -- 「战士」同调怪兽(0x66) 
    -- 龙族同调怪兽
    -- 「废品」怪兽(0x43)
    -- 「星尘」怪兽(0xa3)
    -- 调整怪兽
    local b1 = c:IsSetCard(0x66) and c:IsType(TYPE_SYNCHRO)
    local b2 = c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
    local b3 = c:IsSetCard(0x43)
    local b4 = c:IsSetCard(0xa3)
    local b5 = c:IsType(TYPE_TUNER)
    return b1 and b2 and b3 and b4 and b5
end

---------------------------------------------------------------------
-- 选项 1：流星龙连招
---------------------------------------------------------------------
function s.cfilter1(c)
    -- 包含等级4的「星尘」怪兽或「辉煌的星之龙」(75874514)
    return (c:IsSetCard(0xa3) and c:GetLevel() == 4) or c:IsCode(75874514)
end

function s.op1_con(e, tp, eg, ep, ev, re, r, rp)
    -- 决斗中 1 次
    if Duel.GetFlagEffect(tp, id) > 0 then return false end
    if Duel.GetCurrentChain() ~= 0 or not Duel.IsMainPhase() then return false end
    
    local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
    -- 手卡必须至少2张，且至少包含一张 key 卡
    return #hand >= 2 and hand:IsExists(s.cfilter1, 1, nil) 
        and Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
        and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xa3) and c:GetLevel() == 4 end, tp, LOCATION_DECK, 0, 2, nil)
        and Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_DECK, 0, 1, nil, TYPE_TUNER)
end

function s.op1_op(e, tp, eg, ep, ev, re, r, rp)
    -- 必须手动点击发动（效仿大师效果的隐藏选项机制）
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then return end 
    Duel.RegisterFlagEffect(tp, id, 0, 0, 1)
    
    Duel.Hint(HINT_CARD, 0, id)
    
    -- 1. 手卡洗卡组
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local h1 = Duel.SelectMatchingCard(tp, s.cfilter1, tp, LOCATION_HAND, 0, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local h2 = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_HAND, 0, 1, 1, h1)
    h1:Merge(h2)
    Duel.SendtoDeck(h1, nil, SEQ_DECKSHUFFLE, REASON_RULE)
    
    -- 2. 派2只四星「星尘」到场上
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g_st = Duel.SelectMatchingCard(tp, function(c) return c:IsSetCard(0xa3) and c:GetLevel() == 4 end, tp, LOCATION_DECK, 0, 2, 2, nil)
    if #g_st == 2 then
        for tc in aux.Next(g_st) do
            Duel.MoveToField(tc, tp, tp, LOCATION_MZONE, POS_FACEUP, true)
        end
    end
    
    -- 3. 拿调整
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g_tu = Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_DECK, 0, 1, 1, nil, TYPE_TUNER)
    if #g_tu > 0 then
        Duel.SendtoHand(g_tu, nil, REASON_RULE)
        Duel.ConfirmCards(1-tp, g_tu)
    end
    
    -- 4. 从游戏外印「流星」加入手卡
    local t_meteor = Duel.CreateToken(tp, 47264717) 
    Duel.SendtoHand(t_meteor, nil, REASON_RULE)
    Duel.ConfirmCards(1-tp, t_meteor)
    
    -- 5. 从游戏外把废品转换者(11069680) 和 方程式(50091196) 视作正规出场送墓
    local g=Group.CreateGroup()
    local token1 = Duel.CreateToken(tp, 11069680)
    g:AddCard(token1)
    local token2 = Duel.CreateToken(tp, 50091196)
    g:AddCard(token2)
    -- 模拟正规出场
    token2:SetStatus(STATUS_PROC_COMPLETE, true)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	Duel.RegisterEffect(e2,tp)
	Duel.SendtoGrave(g,REASON_RULE)
    e1:Reset()
	e2:Reset()
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

---------------------------------------------------------------------
-- 选项 2：召唤五龙
---------------------------------------------------------------------
function s.op2_con(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetFlagEffect(tp, id + 1) > 0 then return false end
    if Duel.GetCurrentChain() ~= 0 or not Duel.IsMainPhase() then return false end
    
    local b1 = Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 63436931) -- 红龙
    local b2 = Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) > 0
    return (b1 or b2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function s.op2_op(e, tp, eg, ep, ev, re, r, rp)
    local ct = Duel.GetLocationCount(tp, LOCATION_MZONE)
    if ct <= 0 then return end
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then return end
    Duel.RegisterFlagEffect(tp, id + 1, 0, 0, 1)
    Duel.Hint(HINT_CARD, 0, id)

    -- 黑翼龙：9012916, 古代妖精龙：25862681, 黑蔷薇龙：73580471, 红莲魔龙：70902743, 生命激流龙：25165047
    local code_list = {9012916, 25862681, 73580471, 70902743, 25165047}
    local sel_codes = {}
    local selected = {}

    -- 最多宣言 3 次，且不超过可用怪兽区格子数
    local max_declare = math.min(ct, 3)

    for i = 1, max_declare do
        -- 收集尚未被选择的卡号
        local available = {}
        for _, code in ipairs(code_list) do
            if not selected[code] then
                table.insert(available, code)
            end
        end

        if #available == 0 then break end

        -- 动态构建 afilter
        local afilter = {available[1], OPCODE_ISCODE}
        for j = 2, #available do
            table.insert(afilter, available[j])
            table.insert(afilter, OPCODE_ISCODE)
            table.insert(afilter, OPCODE_OR)
        end

        -- 提示玩家选择要宣告的卡
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CODE)
        local ac = Duel.AnnounceCard(tp, table.unpack(afilter))
        table.insert(sel_codes, ac)
        selected[ac] = true

        if #sel_codes >= max_declare then break end

        -- 询问是否继续宣告
        if not Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then break end
    end

    -- 将未选中的龙送去墓地（以正规出场状态）
    local to_grave = Group.CreateGroup()
    for _, code in ipairs(code_list) do
        if not selected[code] then
            local token = Duel.CreateToken(tp, code)
            token:SetStatus(STATUS_PROC_COMPLETE, true) -- 视作正规出场
            to_grave:AddCard(token)
        end
    end
    if #to_grave > 0 then
        -- 防止被除外或返回卡组（送墓过程中）
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_REMOVE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1, 1)
        e1:SetValue(1)
        Duel.RegisterEffect(e1, tp)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_CANNOT_TO_DECK)
        Duel.RegisterEffect(e2, tp)
        Duel.SendtoGrave(to_grave, REASON_RULE)
        e1:Reset()
        e2:Reset()
    end

    -- 将选中的龙放置到场上
    for _, acode in ipairs(sel_codes) do
        if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
            local tc = Duel.CreateToken(tp, acode)
            tc:SetStatus(STATUS_PROC_COMPLETE, true)
            Duel.MoveToField(tc, tp, tp, LOCATION_MZONE, POS_FACEUP, true)

            -- 非调整怪兽等级变为2星
            if not tc:IsType(TYPE_TUNER) then
                local e1 = Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CHANGE_LEVEL)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
                e1:SetValue(2)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
    end

    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
