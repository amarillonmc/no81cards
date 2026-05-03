-- 万相曲形卡席尔
local COUNTER_FLY = 0x13fd
local COUNTER_DOUBLE = 0x12fd
local COUNTER_DEATHTOUCH = 0x16fd
local COUNTER_ANTI = 0x11fd
local COUNTER_IMMORTAL = 0x1cfd
local COUNTER_LIFELINK = 0x1bfd
local COUNTER_EXTEND = 0x19fd
local COUNTER_TRAMPLE = 0x17cd
local COUNTER_ATKDEF = 0x17fd

function c87531315.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    local e0b=e0:Clone()
    e0b:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e0b)
    local e0c=e0:Clone()
    e0c:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e0c)
    local e0d=e0:Clone()
    e0d:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e0d)
    aux.AddXyzProcedure(c, nil, 5, 3, c87531315.ovfilter, aux.Stringid(87531015,1), 3, c87531315.xyzop)
    c:EnableReviveLimit()
    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531015,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,87531015)
    e1:SetTarget(c87531315.target)
    e1:SetOperation(c87531315.operation)
    c:RegisterEffect(e1)

    local e_atk=Effect.CreateEffect(c)
    e_atk:SetType(EFFECT_TYPE_SINGLE)
    e_atk:SetCode(EFFECT_UPDATE_ATTACK)
    e_atk:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF)*400 end)
    e_atk:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e_atk)
    local e_def=e_atk:Clone()
    e_def:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e_def)
    
    -- 飞行
    local e_fly=Effect.CreateEffect(c)
    e_fly:SetType(EFFECT_TYPE_FIELD)
    e_fly:SetCode(EFFECT_DIRECT_ATTACK)
    e_fly:SetTargetRange(LOCATION_MZONE,0)
    e_fly:SetTarget(c87531315.fly_target)
    e_fly:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_fly,0)

    -- 连击
    local e_double=Effect.CreateEffect(c)
    e_double:SetType(EFFECT_TYPE_FIELD)
    e_double:SetCode(EFFECT_EXTRA_ATTACK)
    e_double:SetTargetRange(LOCATION_MZONE,0)
    e_double:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
    e_double:SetValue(c87531315.double_val)
    e_double:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_double,0)

    -- 死触
    local e_death_battle=Effect.CreateEffect(c)
    e_death_battle:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_death_battle:SetCode(EVENT_BATTLED)
    e_death_battle:SetOperation(c87531315.death_battle_op)
    e_death_battle:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_death_battle,0)
    local e_death_effect=Effect.CreateEffect(c)
    e_death_effect:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_death_effect:SetCode(EVENT_CHAIN_SOLVED)
    e_death_effect:SetOperation(c87531315.death_effect_op)
    e_death_effect:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_death_effect,0)

    -- 辟邪
    local e_anti=Effect.CreateEffect(c)
    e_anti:SetType(EFFECT_TYPE_FIELD)
    e_anti:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e_anti:SetTargetRange(LOCATION_MZONE,0)
    e_anti:SetTarget(c87531315.anti_target)
    e_anti:SetValue(aux.tgoval)
    e_anti:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_anti,0)

    -- 不灭
    local e_immortal1=Effect.CreateEffect(c)
    e_immortal1:SetType(EFFECT_TYPE_FIELD)
    e_immortal1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e_immortal1:SetTargetRange(LOCATION_MZONE,0)
    e_immortal1:SetTarget(c87531315.immortal_target)
    e_immortal1:SetValue(1)
    e_immortal1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_immortal1,0)
    local e_immortal2=e_immortal1:Clone()
    e_immortal2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    Duel.RegisterEffect(e_immortal2,0)

    -- 系命
    local e_lifelink=Effect.CreateEffect(c)
    e_lifelink:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_lifelink:SetCode(EVENT_BATTLE_DAMAGE)
    e_lifelink:SetOperation(c87531315.lifelink_op)
    e_lifelink:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_lifelink,0)

    -- 延势
    local e_extend=Effect.CreateEffect(c)
    e_extend:SetType(EFFECT_TYPE_FIELD)
    e_extend:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e_extend:SetTargetRange(0,LOCATION_MZONE)
    e_extend:SetTarget(c87531315.extend_target)
    e_extend:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_extend,0)

    -- 践踏
    local e_trample=Effect.CreateEffect(c)
    e_trample:SetType(EFFECT_TYPE_FIELD)
    e_trample:SetCode(EFFECT_PIERCE)
    e_trample:SetTargetRange(LOCATION_MZONE,0)
    e_trample:SetTarget(c87531315.trample_target)
    e_trample:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_trample,0)
end

function c87531315.check_cond1(g)
    local races = {RACE_FAIRY, RACE_FIEND, RACE_WINGEDBEAST, RACE_DRAGON}
    local count = 0
    for _, r in ipairs(races) do
        if g:IsExists(Card.IsRace, 1, nil, r) then count = count + 1 end
    end
    return count >= 2
end

function c87531315.check_cond2(g)
    return g:IsExists(function(c)
        return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsRace(RACE_WARRIOR)
    end, 1, nil)
end

function c87531315.check_cond3(g)
    return g:IsExists(Card.IsRace, 1, nil, RACE_INSECT) or
           g:IsExists(Card.IsRace, 1, nil, RACE_REPTILE) or
           g:IsExists(function(c) return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) end, 1, nil)
end

function c87531315.check_cond4(g)
    local attrs = {ATTRIBUTE_LIGHT, ATTRIBUTE_WATER, ATTRIBUTE_EARTH}
    local count = 0
    for _, a in ipairs(attrs) do
        if g:IsExists(Card.IsAttribute, 1, nil, a) then count = count + 1 end
    end
    return count >= 2
end

function c87531315.check_cond5(g)
    local attrs = {ATTRIBUTE_LIGHT, ATTRIBUTE_DARK, ATTRIBUTE_EARTH}
    local count = 0
    for _, a in ipairs(attrs) do
        if g:IsExists(Card.IsAttribute, 1, nil, a) then count = count + 1 end
    end
    return count >= 2
end

function c87531315.check_cond6(g)
    return g:IsExists(Card.IsRace, 1, nil, RACE_FAIRY) or
           g:IsExists(Card.IsRace, 1, nil, RACE_WARRIOR) or
           g:IsExists(Card.IsRace, 1, nil, RACE_ZOMBIE)
end

function c87531315.check_cond7(g)
    return g:IsExists(Card.IsRace, 1, nil, RACE_INSECT) or
           g:IsExists(Card.IsRace, 1, nil, RACE_PLANT) or
           g:IsExists(function(c) return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) end, 1, nil)
end

function c87531315.check_cond8(g)
    return g:IsExists(function(c) return c:IsLevelAbove(8) end, 1, nil)
end

function c87531315.count_conditions(g)
    local cnt = 0
    if c87531315.check_cond1(g) then cnt = cnt + 1 end
    if c87531315.check_cond2(g) then cnt = cnt + 1 end
    if c87531315.check_cond3(g) then cnt = cnt + 1 end
    if c87531315.check_cond4(g) then cnt = cnt + 1 end
    if c87531315.check_cond5(g) then cnt = cnt + 1 end
    if c87531315.check_cond6(g) then cnt = cnt + 1 end
    if c87531315.check_cond7(g) then cnt = cnt + 1 end
    if c87531315.check_cond8(g) then cnt = cnt + 1 end
    return cnt
end

function c87531315.ovfilter(c, xyzc)
    local tp = c:GetControler()
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_GRAVE + LOCATION_REMOVED, LOCATION_GRAVE + LOCATION_REMOVED, nil)
    if c87531315.count_conditions(g) < 5 then return false end
    return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_EARTH))
end

function c87531315.xyzop(e, tp, chk)
    if chk == 0 then
        return Duel.GetFlagEffect(tp, 87531015 + 100) == 0
    end
    Duel.RegisterFlagEffect(tp, 87531015 + 100, RESET_PHASE + PHASE_END, 0, 1)
end

function c87531315.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_GRAVE + LOCATION_REMOVED, LOCATION_GRAVE + LOCATION_REMOVED, nil)
    if c87531315.count_conditions(g) >= 5 then
        Duel.SetChainLimit(c87531315.chlimit)
    end
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 0, 0, 0)
end

function c87531315.chlimit(e, ep, tp)
    return tp == ep
end

function c87531315.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_GRAVE + LOCATION_REMOVED, LOCATION_GRAVE + LOCATION_REMOVED, nil)
    
    if c87531315.count_conditions(g) >= 5 then
        Duel.SetChainLimit(c87531315.chlimit)
    end

    local total_count = 0
    local function place_counter(cond_func, counter_type)
        if cond_func(g) then
            local mg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
            if #mg > 0 then
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
                local tc = mg:Select(tp, 1, 1, nil):GetFirst()
                if tc and tc:IsCanAddCounter(counter_type, 1) then
                    tc:AddCounter(counter_type, 1, REASON_EFFECT)
                    total_count = total_count + 1
                end
            end
        end
    end

    place_counter(c87531315.check_cond1, COUNTER_FLY)
    place_counter(c87531315.check_cond2, COUNTER_DOUBLE)
    place_counter(c87531315.check_cond3, COUNTER_DEATHTOUCH)
    place_counter(c87531315.check_cond4, COUNTER_ANTI)
    place_counter(c87531315.check_cond5, COUNTER_IMMORTAL)
    place_counter(c87531315.check_cond6, COUNTER_LIFELINK)
    place_counter(c87531315.check_cond7, COUNTER_EXTEND)
    place_counter(c87531315.check_cond8, COUNTER_TRAMPLE)

    if total_count > 0 and c:IsCanAddCounter(COUNTER_ATKDEF, total_count) then
        c:AddCounter(COUNTER_ATKDEF, total_count, REASON_EFFECT)
    end
end

function c87531315.fly_target(e, c)
    return c:GetCounter(COUNTER_FLY) > 0
end

function c87531315.double_val(e, c)
    return c:GetCounter(COUNTER_DOUBLE)
end

function c87531315.anti_target(e, c)
    return c:GetCounter(COUNTER_ANTI) > 0
end

function c87531315.immortal_target(e, c)
    return c:GetCounter(COUNTER_IMMORTAL) > 0
end

function c87531315.trample_target(e, c)
    return c:GetCounter(COUNTER_TRAMPLE) > 0
end

function c87531315.extend_target(e, c)
    return c:GetCounter(COUNTER_EXTEND) > 0 and c ~= e:GetHandler()
end

function c87531315.death_battle_op(e, tp, eg, ep, ev, re, r, rp)
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    local function process(mon)
        if mon and mon:GetCounter(COUNTER_DEATHTOUCH) > 0 then
            local opp = (mon == a and d or a)
            if opp and opp:IsRelateToBattle() and opp:IsControler(1 - mon:GetControler()) then
                Duel.Destroy(opp, REASON_EFFECT)
            end
        end
    end
    process(a)
    process(d)
end

function c87531315.death_effect_op(e, tp, eg, ep, ev, re, r, rp)
    local te = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
    if not te then return end
    local c = te:GetHandler()
    if not c or c:GetCounter(COUNTER_DEATHTOUCH) == 0 then return end
    if bit.band(te:GetCategory(), CATEGORY_DEFCHANGE) == 0 then return end
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if not tg then return end
    local opp_tg = tg:Filter(Card.IsControler, nil, 1 - c:GetControler())
    for opp in aux.Next(opp_tg) do
        if opp:IsRelateToChain(ev) then
            Duel.Destroy(opp, REASON_EFFECT)
        end
    end
end

function c87531315.lifelink_op(e, tp, eg, ep, ev, re, r, rp)
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    local function process(mon, owner)
        if mon and mon:GetCounter(COUNTER_LIFELINK) > 0 and mon:IsControler(owner) then
            local dam = Duel.GetBattleDamage(owner)
            if dam > 0 then
                Duel.Recover(owner, dam, REASON_EFFECT)
            end
        end
    end
    process(a, tp)
    process(d, tp)
end