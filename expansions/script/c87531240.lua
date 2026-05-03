-- 伏匿之丝 墓寡妇伊什卡娜

local COUNTER_SHELTER = 0x18fd
local COUNTER_ATKDEF = 0x17fd
local COUNTER_DEATHTOUCH = 0x16fd
local COUNTER_BACKUP = 0x15fd
local COUNTER_EXTEND = 0x19fd
local COUNTER_NEST = 0x14fd
local COUNTER_FLY = 0x13fd
local COUNTER_DOUBLE = 0x12fd
local COUNTER_ANTI = 0x11fd
local COUNTER_IMMORTAL = 0x1cfd
local COUNTER_LIFELINK = 0x1bfd
local COUNTER_TRAMPLE = 0x17cd

local ALL_COUNTERS = {
    COUNTER_SHELTER,
    COUNTER_ATKDEF,
    COUNTER_DEATHTOUCH,
    COUNTER_BACKUP,
    COUNTER_EXTEND,
    COUNTER_NEST,
    COUNTER_FLY,
    COUNTER_DOUBLE,
    COUNTER_ANTI,
    COUNTER_IMMORTAL,
    COUNTER_LIFELINK,
    COUNTER_TRAMPLE,
}

local SPIDER_TOKEN = 87531200
local ALSTA_CARD = 87531235
local DOUBLE_FLAG = 87531220+3000

function c87531240.initial_effect(c)
    for _, ct in ipairs(ALL_COUNTERS) do
        c:EnableCounterPermit(ct)
    end

    aux.AddXyzProcedureLevelFree(c, 
        c87531240.mfilter, nil, 2, 99,
        c87531240.ovfilter, aux.Stringid(87531240,3), c87531240.xyzop
    )
    c:EnableReviveLimit()

    local e_mat=Effect.CreateEffect(c)
    e_mat:SetType(EFFECT_TYPE_SINGLE)
    e_mat:SetCode(EFFECT_MATERIAL_CHECK)
    e_mat:SetValue(c87531240.matcheck)
    c:RegisterEffect(e_mat)

    local e_inherit=Effect.CreateEffect(c)
    e_inherit:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_inherit:SetCode(EVENT_SPSUMMON_SUCCESS)
    e_inherit:SetOperation(c87531240.inherit_op)
    c:RegisterEffect(e_inherit)

    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531240,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,87531240)
    e1:SetCondition(c87531240.e1_con1)
    e1:SetCost(c87531240.e1_cost)
    e1:SetTarget(c87531240.e1_tg)
    e1:SetOperation(c87531240.e1_op)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531240,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,87531240)
    e2:SetCondition(c87531240.e1_con2)
    e2:SetCost(c87531240.e1_cost)
    e2:SetTarget(c87531240.e1_tg)
    e2:SetOperation(c87531240.e1_op)
    c:RegisterEffect(e2)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531240,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,87531240+100)
    e3:SetCondition(c87531240.e2_con_attack)
    e3:SetTarget(c87531240.e2_tg_simple)
    e3:SetOperation(c87531240.e2_op_simple)
    c:RegisterEffect(e3)

    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(87531240,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,87531240+100)
    e4:SetCondition(c87531240.e2_con_target_simple)
    e4:SetTarget(c87531240.e2_tg_simple)
    e4:SetOperation(c87531240.e2_op_simple)
    c:RegisterEffect(e4)

    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(87531240,4))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_BE_BATTLE_TARGET)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,87531240+100)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCondition(c87531240.e2_con_absorb_attack)
    e5:SetTarget(c87531240.e2_tg_absorb_attack)
    e5:SetOperation(c87531240.e2_op_absorb_attack)
    c:RegisterEffect(e5)

    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(87531240,4))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCountLimit(1,87531240+100)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCondition(c87531240.e2_con_absorb_effect)
    e6:SetTarget(c87531240.e2_tg_absorb_effect)
    e6:SetOperation(c87531240.e2_op_absorb_effect)
    c:RegisterEffect(e6)

    -- 庇护指示物
    local e_shelter=Effect.CreateEffect(c)
    e_shelter:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_shelter:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e_shelter:SetRange(LOCATION_MZONE)
    e_shelter:SetCondition(c87531240.shelter_condition)
    e_shelter:SetOperation(c87531240.shelter_operation)
    c:RegisterEffect(e_shelter)

    -- 后盾指示物
    local e_backup=Effect.CreateEffect(c)
    e_backup:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_backup:SetCode(EFFECT_DESTROY_REPLACE)
    e_backup:SetTarget(c87531240.backup_target)
    e_backup:SetOperation(c87531240.backup_operation)
    c:RegisterEffect(e_backup)

    -- 死触指示物
    local e_deathtouch=Effect.CreateEffect(c)
    e_deathtouch:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_deathtouch:SetCode(EVENT_BATTLED)
    e_deathtouch:SetCondition(c87531240.deathtouch_condition)
    e_deathtouch:SetOperation(c87531240.deathtouch_operation)
    c:RegisterEffect(e_deathtouch)

    -- 践踏指示物
    local e_trample=Effect.CreateEffect(c)
    e_trample:SetType(EFFECT_TYPE_SINGLE)
    e_trample:SetCode(EFFECT_PIERCE)
    e_trample:SetCondition(c87531240.trample_condition)
    c:RegisterEffect(e_trample)

    -- 系命指示物
    local e_lifelink=Effect.CreateEffect(c)
    e_lifelink:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_lifelink:SetCode(EVENT_BATTLE_DAMAGE)
    e_lifelink:SetCondition(c87531240.lifelink_condition)
    e_lifelink:SetOperation(c87531240.lifelink_operation)
    c:RegisterEffect(e_lifelink)

    -- 不灭指示物
    local e_indestructible_battle=Effect.CreateEffect(c)
    e_indestructible_battle:SetType(EFFECT_TYPE_SINGLE)
    e_indestructible_battle:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e_indestructible_battle:SetCondition(c87531240.indestructible_condition)
    e_indestructible_battle:SetValue(1)
    c:RegisterEffect(e_indestructible_battle)
    local e_indestructible_effect=e_indestructible_battle:Clone()
    e_indestructible_effect:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e_indestructible_effect)

    -- 辟邪指示物
    local e_anti_target=Effect.CreateEffect(c)
    e_anti_target:SetType(EFFECT_TYPE_SINGLE)
    e_anti_target:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e_anti_target:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e_anti_target:SetRange(LOCATION_MZONE)
    e_anti_target:SetCondition(c87531240.anti_target_condition)
    e_anti_target:SetValue(aux.tgoval)
    c:RegisterEffect(e_anti_target)

    -- 连击指示物
    local e_double_attack=Effect.CreateEffect(c)
    e_double_attack:SetType(EFFECT_TYPE_SINGLE)
    e_double_attack:SetCode(EFFECT_EXTRA_ATTACK)
    e_double_attack:SetCondition(c87531240.double_attack_condition)
    e_double_attack:SetValue(1)
    c:RegisterEffect(e_double_attack)

    -- 飞行指示物
    local e_direct_attack=Effect.CreateEffect(c)
    e_direct_attack:SetType(EFFECT_TYPE_SINGLE)
    e_direct_attack:SetCode(EFFECT_DIRECT_ATTACK)
    e_direct_attack:SetCondition(c87531240.direct_attack_condition)
    c:RegisterEffect(e_direct_attack)
end

-- ========== 超量召唤相关 ==========
function c87531240.mfilter(c, xyzc)
    return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsLevel(4)
end

function c87531240.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xf8a) and c:GetFlagEffect(DOUBLE_FLAG)>0
end

function c87531240.xyzop(e,tp,chk)
    if chk==0 then return true end
end

function c87531240.matcheck(e,c)
    local mg=c:GetMaterial()
    if not mg or mg:GetCount()==0 then return end
    local ct_tbl = {}
    for _, ct in ipairs(ALL_COUNTERS) do ct_tbl[ct]=0 end
    for tc in aux.Next(mg) do
        for _, ct in ipairs(ALL_COUNTERS) do
            local cnt = tc:GetCounter(ct)
            if cnt > 0 then ct_tbl[ct] = ct_tbl[ct] + cnt end
        end
    end
    for ct, total in pairs(ct_tbl) do
        if total > 0 then
            c:RegisterFlagEffect(87531240+ct, 0, 0, 1, total)
        end
    end
end

function c87531240.inherit_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() then return end
    for _, ct in ipairs(ALL_COUNTERS) do
        local cnt = c:GetFlagEffectLabel(87531240+ct)
        if cnt and cnt > 0 then
            if c:IsCanAddCounter(ct, cnt) then
                c:AddCounter(ct, cnt, REASON_EFFECT)
            end
            c:ResetFlagEffect(87531240+ct)
        end
    end
end

-- ========== ①效果 ==========
function c87531240.search_filter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c87531240.e1_con1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c87531240.e1_con2(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end

function c87531240.e1_cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c87531240.e1_tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c87531240.search_filter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function c87531240.e1_op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, c87531240.search_filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1-tp, g)
    end
    local mg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_GRAVE, 0, nil, TYPE_MONSTER)
    local count, names = 0, {}
    for tc in aux.Next(mg) do
        local code = tc:GetOriginalCode()
        if not names[code] then
            names[code] = true
            count = count + 1
        end
    end
    if count >= 4 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsPlayerCanSpecialSummonMonster(tp, SPIDER_TOKEN, 0xf8a, TYPES_TOKEN_MONSTER, 400, 800, 4, RACE_INSECT, ATTRIBUTE_EARTH)
        and Duel.SelectYesNo(tp, aux.Stringid(87531240, 2)) then
        Duel.BreakEffect()
        local token = Duel.CreateToken(tp, SPIDER_TOKEN)
        Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ========== ②效果==========
function c87531240.HasAlasta()
    local field_g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ALSTA_CARD)
    for tc in aux.Next(field_g) do
        if tc:IsFaceup() and not tc:IsDisabled() then return true end
    end
    return Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ALSTA_CARD)
end

function c87531240.e2_con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end
function c87531240.e2_tg_simple(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c87531240.e2_op_simple(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c87531240.e2_con_target_simple(e,tp,eg,ep,ev,re,r,rp)
    local has_alasta=c87531240.HasAlasta()
    for i=1, Duel.GetCurrentChain() do
        local te, tgp, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TARGET_CARDS)
        if te and tg then
            if tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then
                return true
            end
            if has_alasta and tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_GRAVE) and tc~=e:GetHandler() end,1,nil) then
                return true
            end
        end
    end
    return false
end

function c87531240.e2_con_absorb_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if not (tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then return false end
    local at=Duel.GetAttacker()
    local def=Duel.GetAttackTarget()
    return def and def:IsControler(tp) and at and at:IsControler(1-tp) and def:IsFaceup() and at:IsFaceup()
end
function c87531240.e2_tg_absorb_attack(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    local at=Duel.GetAttacker()
    local def=Duel.GetAttackTarget()
    Duel.SetTargetCard(def)
    Duel.SetTargetCard(at)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c87531240.e2_op_absorb_attack(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tg=Duel.GetTargetsRelateToChain()
    if tg:GetCount()~=2 then return end
    local mycard=tg:Filter(Card.IsControler,nil,tp):GetFirst()
    local oppcard=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
    if mycard and mycard:IsFaceup() and mycard:IsRelateToEffect(e)
        and oppcard and oppcard:IsFaceup() and oppcard:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            Duel.NegateAttack()
            oppcard:CancelToGrave()
            local ct_tbl = {}
            for _, ct in ipairs(ALL_COUNTERS) do
                ct_tbl[ct] = mycard:GetCounter(ct)
            end
            local og1=mycard:GetOverlayGroup()
            if #og1>0 then Duel.SendtoGrave(og1,REASON_RULE) end
            local og2=oppcard:GetOverlayGroup()
            if #og2>0 then Duel.SendtoGrave(og2,REASON_RULE) end
            Duel.Overlay(c, Group.FromCards(mycard, oppcard))
            for ct, cnt in pairs(ct_tbl) do
                if cnt>0 and c:IsCanAddCounter(ct, cnt) then
                    c:AddCounter(ct, cnt, REASON_EFFECT)
                end
            end
        end
    end
end

function c87531240.e2_con_absorb_effect(e,tp,eg,ep,ev,re,r,rp)
    for i=1, Duel.GetCurrentChain() do
        local te, tgp, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TARGET_CARDS)
        if te and tgp==1-tp and tg then
            if tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then
                return true
            end
            if c87531240.HasAlasta() and tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_GRAVE) and tc~=e:GetHandler() end,1,nil) then
                return true
            end
        end
    end
    return false
end
function c87531240.e2_tg_absorb_effect(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    local options = {}
    local chain_ids = {}
    local mycards = {}
    local oppcards = {}
    local has_alasta = c87531240.HasAlasta()
    for i=1, Duel.GetCurrentChain() do
        local te, tgp, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TARGET_CARDS)
        if te and tgp==1-tp and tg then
            local mycard = nil
            if tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then
                mycard = tg:Filter(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end, nil):GetFirst()
            elseif has_alasta then
                local grave_cards = tg:Filter(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_GRAVE) and tc~=c end, nil)
                if #grave_cards>0 then
                    mycard = grave_cards:GetFirst()
                end
            end
            if mycard then
                local oppcard = te:GetHandler()
                if oppcard and oppcard:IsOnField() then
                    local code = oppcard:GetOriginalCode()
                    table.insert(options, "Card " .. code .. " (" .. i .. ")")
                    table.insert(chain_ids, i)
                    table.insert(mycards, mycard)
                    table.insert(oppcards, oppcard)
                end
            end
        end
    end
    if #options == 0 then return end
    local choice
    if #options == 1 then
        choice = 1
    else
        choice = Duel.SelectOption(tp, table.unpack(options)) + 1
    end
    local selected_chain = chain_ids[choice]
    local mycard = mycards[choice]
    local oppcard = oppcards[choice]
    Duel.SetTargetCard(mycard)
    Duel.SetTargetCard(oppcard)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    e:SetLabel(selected_chain)
end
function c87531240.e2_op_absorb_effect(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tg=Duel.GetTargetsRelateToChain()
    if tg:GetCount()~=2 then return end
    local mycard=tg:Filter(Card.IsControler,nil,tp):GetFirst()
    local oppcard=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
    if mycard and (mycard:IsFaceup() or mycard:IsLocation(LOCATION_GRAVE)) and mycard:IsRelateToEffect(e)
        and oppcard and oppcard:IsFaceup() and oppcard:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            local chain_id = e:GetLabel()
            if chain_id > 0 then
                Duel.NegateEffect(chain_id)
            end
            oppcard:CancelToGrave()
            -- 统计自己怪兽上的指示物（仅当怪兽在场上有指示物时）
            local ct_tbl = {}
            if mycard:IsLocation(LOCATION_MZONE) then
                for _, ct in ipairs(ALL_COUNTERS) do
                    ct_tbl[ct] = mycard:GetCounter(ct)
                end
            else
                for _, ct in ipairs(ALL_COUNTERS) do ct_tbl[ct]=0 end
            end
            if mycard:IsLocation(LOCATION_GRAVE) then
                Duel.Overlay(c, Group.FromCards(mycard))
            else
                local og1=mycard:GetOverlayGroup()
                if #og1>0 then Duel.SendtoGrave(og1,REASON_RULE) end
                Duel.Overlay(c, Group.FromCards(mycard))
            end
            local og2=oppcard:GetOverlayGroup()
            if #og2>0 then Duel.SendtoGrave(og2,REASON_RULE) end
            Duel.Overlay(c, Group.FromCards(oppcard))
            for ct, cnt in pairs(ct_tbl) do
                if cnt>0 and c:IsCanAddCounter(ct, cnt) then
                    c:AddCounter(ct, cnt, REASON_EFFECT)
                end
            end
        end
    end
end

-- ========== 指示物效果 ==========
function c87531240.shelter_condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a==c or d==c) and c:GetCounter(COUNTER_SHELTER)>0
end
function c87531240.shelter_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local owner=c:GetControler()
    local dam=Duel.GetBattleDamage(owner)
    if dam>0 then
        Duel.ChangeBattleDamage(owner,0)
        c:RemoveCounter(owner,COUNTER_SHELTER,1,REASON_EFFECT)
    end
end

function c87531240.backup_target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:GetCounter(COUNTER_BACKUP)>0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
    end
    return Duel.SelectEffectYesNo(tp,c,aux.Stringid(87531240,5))
end
function c87531240.backup_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RemoveCounter(tp,COUNTER_BACKUP,1,REASON_EFFECT)
end

function c87531240.deathtouch_condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:GetCounter(COUNTER_DEATHTOUCH)>0 and bc and bc:IsRelateToBattle() and bc:IsControler(1-tp)
end
function c87531240.deathtouch_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
        Duel.Destroy(bc,REASON_EFFECT)
    end
end

function c87531240.trample_condition(e)
    return e:GetHandler():GetCounter(COUNTER_TRAMPLE)>0
end

function c87531240.lifelink_condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetCounter(COUNTER_LIFELINK)>0 and c:GetBattleTarget() and c:GetBattleTarget():IsControler(1-tp)
end
function c87531240.lifelink_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local dam=Duel.GetBattleDamage(tp)
    if dam>0 then
        Duel.Recover(tp,dam,REASON_EFFECT)
    end
end

function c87531240.indestructible_condition(e)
    return e:GetHandler():GetCounter(COUNTER_IMMORTAL)>0
end

function c87531240.anti_target_condition(e)
    return e:GetHandler():GetCounter(COUNTER_ANTI)>0
end

function c87531240.double_attack_condition(e)
    return e:GetHandler():GetCounter(COUNTER_DOUBLE)>0
end

function c87531240.direct_attack_condition(e)
    return e:GetHandler():GetCounter(COUNTER_FLY)>0
end