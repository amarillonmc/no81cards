-- 卡号
function c10111168.initial_effect(c)
    -- 控制者在每次自己结束阶段支付2000基本分
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
	e1:SetCondition(c10111168.mtcon)
	e1:SetOperation(c10111168.mtop)
    c:RegisterEffect(e1)

    -- ①效果：特殊召唤
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1, 10111168)
    e3:SetCondition(c10111168.spcon)
    e3:SetOperation(c10111168.spop)
    c:RegisterEffect(e3)

   -- ②效果：禁用怪兽区域
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DISABLE_FIELD)
    e4:SetOperation(c10111168.disop)
    c:RegisterEffect(e4)
end

-- 支付2000基本分的条件
function c10111168.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10111168.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,2000) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end

-- ①效果：特殊召唤的条件
function c10111168.spcon(e, tp, eg, ep, ev, re, r, rp)
    -- 检查第三个主要怪兽区域是否为空
    local seq = 2 -- 第三个主要怪兽区域的索引（从左往右数，索引从0开始）
    local zone = 0x1 << seq -- 将索引转换为区域掩码
    return Duel.GetLocationCount(tp, LOCATION_MZONE, tp, 0, zone) > 0
end

-- ①效果：特殊召唤的操作
function c10111168.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        -- 指定特殊召唤的位置为第三个主要怪兽区域
        local seq = 2 -- 主要怪兽区域的第三个格子（从左往右数，索引从0开始）
        local pos = POS_FACEUP
        local zone = 0x1 << seq -- 将索引转换为区域掩码
        Duel.SpecialSummon(c, 0, tp, tp, false, false, pos, zone)
    end
end

-- ②效果：禁用怪兽区域的操作
function c10111168.disop(e, tp)
    -- 选择自己场上的2个怪兽区域
    local self_dis = 0
    for i = 1, 2 do
        local dis = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, 0, 0)
        if dis == 0 then return 0 end -- 如果没有选择区域，则返回0
        self_dis = bit.bor(self_dis, dis)
    end

    -- 选择对方场上的2个怪兽区域
    local opp_dis = 0
    for i = 1, 2 do
        local dis = Duel.SelectDisableField(tp, 1, 0, LOCATION_MZONE, 0)
        if dis == 0 then return 0 end -- 如果没有选择区域，则返回0
        opp_dis = bit.bor(opp_dis, dis)
    end

    -- 合并自己和对方的禁用区域
    return bit.bor(self_dis, opp_dis)
end