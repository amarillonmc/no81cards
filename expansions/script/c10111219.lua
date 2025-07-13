-- 强欲指示物怪兽
local s, id = GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0xd)
    c:SetCounterLimit(0xd,10)
	c:EnableReviveLimit()

	--material
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2)

    -- ①效果：每次抽卡放置强欲指示物
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_DRAW)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.indcon)
    e1:SetOperation(s.indop)
    c:RegisterEffect(e1)
    
    -- ②效果：根据指示物数量获得不同效果
    -- 1个以上：攻击力上升
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
    
    -- 3个以上：抽卡效果
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(s.drawcon)
    e3:SetTarget(s.drawtg)
    e3:SetOperation(s.drawop)
    c:RegisterEffect(e3)
    
    -- 6个以上：抗性效果
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetCondition(s.rescon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetCondition(s.rescon)
    e5:SetValue(aux.tgoval)
    c:RegisterEffect(e5)
    
    -- 9个以上：封锁加卡效果
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EFFECT_CANNOT_ADD_TO_HAND)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,1)
    e6:SetCondition(s.lockcon)
    e6:SetTarget(s.locktg)
    c:RegisterEffect(e6)
end

-- 强欲指示物计数器定义
s.counter_place_list = {0xd} -- 强欲指示物

-- ①效果：放置强欲指示物的条件
function s.indcon(e, tp, eg, ep, ev, re, r, rp)
    return ep == tp and e:GetHandler():IsLocation(LOCATION_MZONE)
end

-- ①效果：放置强欲指示物操作
function s.indop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:GetCounter(0xd) < 10 then -- 最多10个指示物
        c:AddCounter(0xd,1)
    end
end

-- ②效果：攻击力提升计算
function s.atkval(e, c)
    local count = c:GetCounter(0xd)
    if count >= 1 then
        return count * 500
    else
        return 0
    end
end

-- ②效果：抽卡效果条件（3个以上指示物）
function s.drawcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetCounter(0xd) >= 3
end

-- ②效果：抽卡目标设置
function s.drawtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- ②效果：抽卡操作
function s.drawop(e, tp, eg, ep, ev, re, r, rp)
    local p,d = Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end

-- ②效果：抗性条件（6个以上指示物）
function s.rescon(e)
    return e:GetHandler():GetCounter(0xd) >= 6
end

-- ②效果：封锁加卡条件（9个以上指示物）
function s.lockcon(e)
    return e:GetHandler():GetCounter(0xd) >= 9
end

-- ②效果：封锁加卡目标过滤
function s.locktg(e, c)
    return not c:IsLocation(LOCATION_DECK) or not c:IsReason(REASON_DRAW)
end