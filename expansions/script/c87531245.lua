-- 伏匿之丝 败坏林地
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

local TRANSFERABLE_COUNTERS = {
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

local TEXT_PLACE_FZONE = 0
local TEXT_PLACE_SZONE = 1
local TEXT_REPLACE_SHELTER = 2
local TEXT_REPLACE_BACKUP = 3
local CT_TEXT_BASE = 4
local CT_TEXT_ID = {
    [COUNTER_SHELTER] = CT_TEXT_BASE,
    [COUNTER_ATKDEF] = CT_TEXT_BASE + 1,
    [COUNTER_DEATHTOUCH] = CT_TEXT_BASE + 2,
    [COUNTER_BACKUP] = CT_TEXT_BASE + 3,
    [COUNTER_EXTEND] = CT_TEXT_BASE + 4,
    [COUNTER_NEST] = CT_TEXT_BASE + 5,
    [COUNTER_FLY] = CT_TEXT_BASE + 6,
    [COUNTER_DOUBLE] = CT_TEXT_BASE + 7,
    [COUNTER_ANTI] = CT_TEXT_BASE + 8,
    [COUNTER_IMMORTAL] = CT_TEXT_BASE + 9,
    [COUNTER_LIFELINK] = CT_TEXT_BASE + 10,
    [COUNTER_TRAMPLE] = CT_TEXT_BASE + 11,
}

function c87531245.initial_effect(c)
    for _, ct in ipairs(ALL_COUNTERS) do
        c:EnableCounterPermit(ct)
    end

    -- ①作为场地魔法发动
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetDescription(aux.Stringid(87531245, TEXT_PLACE_FZONE))
    c:RegisterEffect(e1)

    -- ④当作永续陷阱放置
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(87531245, TEXT_PLACE_SZONE))
    e4:SetCategory(CATEGORY_LEAVE_GRAVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetTarget(c87531245.settg)
    e4:SetOperation(c87531245.setop)
    c:RegisterEffect(e4)

    -- ②场地魔法形态下的指示物移动
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
    e2:SetTarget(c87531245.tg2)
    e2:SetOperation(c87531245.op2)
    c:RegisterEffect(e2)

    -- ⑤永续陷阱形态下的指示物移动
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_COUNTER)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_SZONE)
    e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
    e5:SetCondition(c87531245.trap_cond)
    e5:SetTarget(c87531245.tg5)
    e5:SetOperation(c87531245.op5)
    c:RegisterEffect(e5)

    -- ⑥检索
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_MOVE)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1,87531245+400)
    e6:SetCondition(c87531245.search_condition)
    e6:SetTarget(c87531245.acttg)
    e6:SetOperation(c87531245.actop)
    c:RegisterEffect(e6)

    -- 吸收离场卡的指示物
    local e_absorb=Effect.CreateEffect(c)
    e_absorb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_absorb:SetCode(EVENT_LEAVE_FIELD_P)
    e_absorb:SetRange(LOCATION_FZONE+LOCATION_SZONE)
    e_absorb:SetOperation(c87531245.absorb_op)
    c:RegisterEffect(e_absorb)
end

function RegisterBackupCounterReplace(card)
    if card:GetFlagEffect(87531245+2000) ~= 0 then return end
    card:RegisterFlagEffect(87531245+2000, RESET_EVENT+RESETS_STANDARD, 0, 1)

    local e_replace = Effect.CreateEffect(card)
    e_replace:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e_replace:SetCode(EFFECT_DESTROY_REPLACE)
    e_replace:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c = e:GetHandler()
        if chk == 0 then
            return c:GetCounter(COUNTER_BACKUP) > 0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
        end
        return Duel.SelectEffectYesNo(tp, c, aux.Stringid(87531215,5))
    end)
    e_replace:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        c:RemoveCounter(tp, COUNTER_BACKUP, 1, REASON_EFFECT)
    end)
    e_replace:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    card:RegisterEffect(e_replace)
end

function c87531245.thfilter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c87531245.has_target(tp)
    return Duel.IsExistingMatchingCard(c87531245.thfilter, tp, LOCATION_DECK, 0, 1, nil)
end
function c87531245.search_op(e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c87531245.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c87531245.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return c87531245.has_target(tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87531245.actop(e,tp,eg,ep,ev,re,r,rp)
    c87531245.search_op(e,tp)
end

function c87531245.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c87531245.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        c:RegisterFlagEffect(87531245, RESET_EVENT+RESETS_STANDARD, 0, 1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        c:RegisterEffect(e1)
    end
end

function c87531245.trap_cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(87531245)>0
        and e:GetHandler():IsLocation(LOCATION_SZONE)
end

function c87531245.search_condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_HAND)
        and c87531245.has_target(tp)
end

function c87531245.card_replace_used(c)
    return c:GetFlagEffect(87531245+2) > 0
end
function c87531245.set_card_replace_used(c)
    c:RegisterFlagEffect(87531245+2, RESET_PHASE+PHASE_END, 0, 1)
end

function c87531245.do_transfer(e,tp, c, tc, is_trap)
    local has_ct = false
    for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
        if c:GetCounter(ct) > 0 then has_ct = true break end
    end
    if has_ct then
        for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
            local cur = c:GetCounter(ct)
            if cur > 0 then
                if Duel.SelectYesNo(tp, aux.Stringid(87531245, CT_TEXT_ID[ct])) then
                    local list = {}
                    for i=1, cur do table.insert(list, i) end
                    local num = Duel.AnnounceNumber(tp, table.unpack(list))
                    if num > 0 then
                        c:RemoveCounter(tp, ct, num, REASON_EFFECT)
                        tc:AddCounter(ct, num, REASON_EFFECT)
                        if ct == COUNTER_BACKUP and tc:IsType(TYPE_MONSTER) then
                            RegisterBackupCounterReplace(tc)
                        end
                    end
                end
            end
        end
    else
        if c87531245.card_replace_used(c) then return end
        local op = Duel.SelectOption(tp, aux.Stringid(87531245, TEXT_REPLACE_SHELTER), aux.Stringid(87531245, TEXT_REPLACE_BACKUP))
        local ct = (op==0) and COUNTER_SHELTER or COUNTER_BACKUP
        if tc:IsCanAddCounter(ct,1) then
            tc:AddCounter(ct,1,REASON_EFFECT)
            c87531245.set_card_replace_used(c)
            if ct == COUNTER_BACKUP and tc:IsType(TYPE_MONSTER) then
                RegisterBackupCounterReplace(tc)
            end
        end
    end
end

function c87531245.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsSetCard(0xf8a) end
    if chk==0 then
        return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0xf8a)
            and not c87531245.card_replace_used(c)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,nil,0xf8a)
end
function c87531245.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
    c87531245.do_transfer(e,tp, c, tc, false)
end

function c87531245.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsSetCard(0xf8a) end
    if chk==0 then
        return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0xf8a)
            and not c87531245.card_replace_used(c)
            and c:GetFlagEffect(87531245)>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,nil,0xf8a)
end
function c87531245.op5(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(87531245)==0 then return end
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
    c87531245.do_transfer(e,tp, c, tc, true)
end

function c87531245.absorb_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local add_tbl = {}
    for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
        add_tbl[ct] = 0
    end
    for tc in aux.Next(eg) do
        if tc ~= c and tc:IsPreviousControler(tp) then
            for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
                local cnt = tc:GetCounter(ct)
                if cnt > 0 then
                    add_tbl[ct] = add_tbl[ct] + cnt
                end
            end
        end
    end
    for ct, cnt in pairs(add_tbl) do
        if cnt > 0 and c:IsCanAddCounter(ct, cnt) then
            c:AddCounter(ct, cnt, REASON_EFFECT)
        end
    end
end