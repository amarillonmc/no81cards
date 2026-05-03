-- 伏匿之丝 双胞丝蛛
-- 卡号 87531220
-- 系列 setcode 0xf8a

local COUNTER_EXTEND = 0x19fd
local ALSTA_CARD = 87531235
local EGG_CARD = 87531225
local SPIDER_TOKEN = 87531200
local DOUBLE_FLAG = 87531220+3000

function c87531220.initial_effect(c)
    c:EnableCounterPermit(COUNTER_EXTEND)

    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531220,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,87531220)
    e1:SetCondition(c87531220.con_attack)
    e1:SetTarget(c87531220.tg1)
    e1:SetOperation(c87531220.op1)
    c:RegisterEffect(e1)

    local e2=e1:Clone()
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
    e2:SetCondition(c87531220.con_target)
    c:RegisterEffect(e2)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531220,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,87531220+100)
    e3:SetTarget(c87531220.tg2)
    e3:SetOperation(c87531220.op2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)

    -- 延势指示物的攻击限制效果（不可无效）
    local e_taunt=Effect.CreateEffect(c)
    e_taunt:SetType(EFFECT_TYPE_FIELD)
    e_taunt:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e_taunt:SetRange(LOCATION_MZONE)
    e_taunt:SetTargetRange(0,LOCATION_MZONE)
    e_taunt:SetCondition(c87531220.tauntcon)
    e_taunt:SetValue(c87531220.atlimit)
    e_taunt:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  -- 添加不可无效属性
    c:RegisterEffect(e_taunt)
end

function c87531220.HasAlasta()
    local field_g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ALSTA_CARD)
    for tc in aux.Next(field_g) do
        if tc:IsFaceup() and not tc:IsDisabled() then return true end
    end
    return Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ALSTA_CARD)
end

function c87531220.tauntcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(function(c) return c:GetCounter(COUNTER_EXTEND)>0 end, tp, LOCATION_MZONE, 0, 1, nil)
end

function c87531220.atlimit(e, c)
    return c ~= e:GetHandler()
end

function c87531220.con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end

function c87531220.con_target(e,tp,eg,ep,ev,re,r,rp)
    local has_alasta=c87531220.HasAlasta()
    for i=1, Duel.GetCurrentChain() do
        local te, tgp, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TARGET_CARDS)
        if te and tg then
            if tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then return true end
            if has_alasta and tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_GRAVE) end,1,nil) then return true end
        end
    end
    return false
end

function c87531220.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local loc=c:GetLocation()
    local can_sp=(loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    if chk==0 then return can_sp end
    local op=0
    if loc==LOCATION_HAND then
        local has_target=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        if has_target and Duel.SelectYesNo(tp,aux.Stringid(87531220,2)) then
            op=1
            e:SetProperty(EFFECT_FLAG_CARD_TARGET)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        else op=0 e:SetProperty(0) end
    else op=0 e:SetProperty(0) end
    e:SetLabel(op)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    if op==1 then Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0) end
end

function c87531220.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local loc=c:GetLocation()
    if (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            c:RegisterFlagEffect(87531220,RESET_EVENT+RESETS_STANDARD,0,1)
            local op=e:GetLabel()
            if loc==LOCATION_HAND and op==1 then
                local tc=Duel.GetFirstTarget()
                if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanAddCounter(COUNTER_EXTEND,1) then
                    tc:AddCounter(COUNTER_EXTEND,1,REASON_EFFECT)
                end
            end
        end
    end
end

function c87531220.double_target(e,c) return c:IsSetCard(0xf8a) and c:IsType(TYPE_XYZ) end

function c87531220.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local special_flag = c:GetFlagEffect(87531220)>0 or (re and re:GetHandler():IsCode(EGG_CARD))
    local b1=true
    local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,SPIDER_TOKEN,0xf8a,TYPES_TOKEN_MONSTER,400,800,4,RACE_INSECT,ATTRIBUTE_EARTH)
    if chk==0 then return b1 or b2 end
    local ops,texts={},{}
    if b1 then table.insert(ops,1) table.insert(texts,aux.Stringid(87531220,3)) end
    if b2 then table.insert(ops,2) table.insert(texts,aux.Stringid(87531220,4)) end
    if b1 and b2 and special_flag then table.insert(ops,3) table.insert(texts,aux.Stringid(87531220,5)) end
    local op_index = (#ops==1) and 1 or Duel.SelectOption(tp,table.unpack(texts))+1
    local selected=ops[op_index]
    e:SetLabel(selected)
    if selected==1 or selected==3 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0) end
    if selected==2 or selected==3 then
        Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
end

function c87531220.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local selected=e:GetLabel()
    if selected==1 or selected==3 then
        local e_double=Effect.CreateEffect(c)
        e_double:SetType(EFFECT_TYPE_SINGLE)
        e_double:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e_double:SetCode(EFFECT_DOUBLE_XMATERIAL)
        e_double:SetRange(LOCATION_MZONE)
        e_double:SetTarget(c87531220.double_target)
        e_double:SetValue(1)
        e_double:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e_double,true)
        c:RegisterFlagEffect(DOUBLE_FLAG, RESET_EVENT+RESETS_STANDARD, 0, 1)
    end
    if selected==2 or selected==3 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        if not Duel.IsPlayerCanSpecialSummonMonster(tp,SPIDER_TOKEN,0xf8a,TYPES_TOKEN_MONSTER,400,800,4,RACE_INSECT,ATTRIBUTE_EARTH) then return end
        local token=Duel.CreateToken(tp,SPIDER_TOKEN)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end