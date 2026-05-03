-- 伏匿之丝 抽肢娃娃
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
local COUNTER_TANGLE = 0x1dcd

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
    COUNTER_TANGLE,
}

local FLAG_BACKUP = 87531230 + 1  

function c87531230.initial_effect(c)
    for _, ct in ipairs(ALL_COUNTERS) do
        c:EnableCounterPermit(ct)
    end

    aux.AddLinkProcedure(c, nil, 2, 99, c87531230.lcheck)
    c:EnableReviveLimit()

    local e_mat=Effect.CreateEffect(c)
    e_mat:SetType(EFFECT_TYPE_SINGLE)
    e_mat:SetCode(EFFECT_MATERIAL_CHECK)
    e_mat:SetValue(c87531230.matcheck)
    c:RegisterEffect(e_mat)

    local e_inherit=Effect.CreateEffect(c)
    e_inherit:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_inherit:SetCode(EVENT_SPSUMMON_SUCCESS)
    e_inherit:SetOperation(c87531230.inherit_op)
    c:RegisterEffect(e_inherit)

    -- ①效
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531230,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,87531230)
    e2:SetHintTiming(TIMING_MAIN_END+TIMING_END_PHASE)
    e2:SetCondition(c87531230.effcon)
    e2:SetTarget(c87531230.efftg)
    e2:SetOperation(c87531230.effop)
    c:RegisterEffect(e2)

    -- 窝巢
    local e_leave=Effect.CreateEffect(c)
    e_leave:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_leave:SetCode(EVENT_LEAVE_FIELD_P)
    e_leave:SetOperation(c87531230.leaveop)
    c:RegisterEffect(e_leave)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531230,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c87531230.tkcon)
    e3:SetTarget(c87531230.tktg)
    e3:SetOperation(c87531230.tkop)
    e3:SetLabelObject(e_leave)
    c:RegisterEffect(e3)

    -- 庇护
    local e_shelter = Effect.CreateEffect(c)
    e_shelter:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_shelter:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e_shelter:SetOperation(c87531230.shelter_op)
    e_shelter:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_shelter, 0)

    -- 连击
    local e_double = Effect.CreateEffect(c)
    e_double:SetType(EFFECT_TYPE_FIELD)
    e_double:SetCode(EFFECT_EXTRA_ATTACK)
    e_double:SetTargetRange(LOCATION_MZONE, 0)
    e_double:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
    e_double:SetValue(c87531230.double_val)
    e_double:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_double, 0)

    -- 飞行
    local e_fly = Effect.CreateEffect(c)
    e_fly:SetType(EFFECT_TYPE_FIELD)
    e_fly:SetCode(EFFECT_DIRECT_ATTACK)
    e_fly:SetTargetRange(LOCATION_MZONE, 0)
    e_fly:SetTarget(c87531230.fly_target)
    e_fly:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_fly, 0)

    -- 辟邪
    local e_anti = Effect.CreateEffect(c)
    e_anti:SetType(EFFECT_TYPE_FIELD)
    e_anti:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e_anti:SetTargetRange(LOCATION_MZONE, 0)
    e_anti:SetTarget(c87531230.anti_target)
    e_anti:SetValue(aux.tgoval)
    e_anti:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_anti, 0)

    -- 不灭
    local e_immortal1 = Effect.CreateEffect(c)
    e_immortal1:SetType(EFFECT_TYPE_FIELD)
    e_immortal1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e_immortal1:SetTargetRange(LOCATION_MZONE, 0)
    e_immortal1:SetTarget(c87531230.immortal_target)
    e_immortal1:SetValue(1)
    e_immortal1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_immortal1, 0)
    local e_immortal2 = e_immortal1:Clone()
    e_immortal2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    Duel.RegisterEffect(e_immortal2, 0)

    -- 系命
    local e_lifelink = Effect.CreateEffect(c)
    e_lifelink:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_lifelink:SetCode(EVENT_BATTLE_DAMAGE)
    e_lifelink:SetOperation(c87531230.lifelink_op)
    e_lifelink:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_lifelink, 0)

    -- 践踏
    local e_trample = Effect.CreateEffect(c)
    e_trample:SetType(EFFECT_TYPE_FIELD)
    e_trample:SetCode(EFFECT_PIERCE)
    e_trample:SetTargetRange(LOCATION_MZONE, 0)
    e_trample:SetTarget(c87531230.trample_target)
    e_trample:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_trample, 0)
end

function c87531230.lcheck(g, lc)
    local honka = 0
    for tc in aux.Next(g) do
        if tc:IsSetCard(0xf8a) then honka = honka + 1 end
    end
    return honka >= 1
end

function c87531230.matcheck(e,c)
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
            c:RegisterFlagEffect(87531230+ct, 0, 0, 1, total)
        end
    end
end

function c87531230.inherit_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() then return end
    for _, ct in ipairs(ALL_COUNTERS) do
        local cnt = c:GetFlagEffectLabel(87531230+ct)
        if cnt and cnt > 0 then
            if c:IsCanAddCounter(ct, cnt) then
                c:AddCounter(ct, cnt, REASON_EFFECT)
                if ct == COUNTER_BACKUP then
                    if c:GetFlagEffect(FLAG_BACKUP)==0 then
                        local e_replace=Effect.CreateEffect(c)
                        e_replace:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
                        e_replace:SetCode(EFFECT_DESTROY_REPLACE)
                        e_replace:SetTarget(c87531230.reptg)
                        e_replace:SetOperation(c87531230.repop)
                        e_replace:SetReset(RESET_EVENT+RESETS_STANDARD)
                        e_replace:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                        c:RegisterEffect(e_replace, true)
                        c:RegisterFlagEffect(FLAG_BACKUP,RESET_EVENT+RESETS_STANDARD,0,1)
                    end
                end
            end
            c:ResetFlagEffect(87531230+ct)
        end
    end
end

function c87531230.effcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_END
end

function c87531230.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
            and chkc:IsSetCard(0xf8a) and chkc:IsType(TYPE_MONSTER)
    end
    if chk==0 then
        return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xf8a)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0xf8a)
    local op=Duel.SelectOption(tp,aux.Stringid(87531230,2),aux.Stringid(87531230,3))
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    else
        e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_COUNTER)
        Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
end

function c87531230.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end
    local op=e:GetLabel()
    if op==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    else
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local token=Duel.CreateToken(tp,87531200)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanAddCounter(COUNTER_NEST,1) then
            c:AddCounter(COUNTER_NEST,1,REASON_EFFECT)
        end
        Duel.SpecialSummonComplete()
    end
end

function c87531230.leaveop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetCounter(COUNTER_NEST)
    e:SetLabel(ct)
end

function c87531230.tkcon(e,tp,eg,ep,ev,re,r,rp)
    local leave_eff=e:GetLabelObject()
    return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and leave_eff:GetLabel()>0
end

function c87531230.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local leave_eff=e:GetLabelObject()
    local maxct=leave_eff:GetLabel()
    if chk==0 then
        return maxct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    local num=1
    if maxct>1 then
        local nums={}
        for i=1,maxct do table.insert(nums,i) end
        num=Duel.AnnounceNumber(tp,table.unpack(nums))
    end
    e:SetLabel(num)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,num,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,num,0,0)
end

function c87531230.tkop(e,tp,eg,ep,ev,re,r,rp)
    local num=e:GetLabel()
    if num<=0 then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<num then return end
    for i=1,num do
        local token=Duel.CreateToken(tp,87531200)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
end

function c87531230.shelter_op(e, tp, eg, ep, ev, re, r, rp)
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    if not a or not d then return end
    local function process(mon)
        if mon and mon:GetCounter(COUNTER_SHELTER) > 0 then
            local owner = mon:GetControler()
            local dam = Duel.GetBattleDamage(owner)
            if dam > 0 then
                Duel.ChangeBattleDamage(owner, 0)
                mon:RemoveCounter(owner, COUNTER_SHELTER, 1, REASON_EFFECT)
            end
        end
    end
    process(a)
    process(d)
end

function c87531230.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:GetCounter(COUNTER_BACKUP)>0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
    end
    return Duel.SelectEffectYesNo(tp,c,aux.Stringid(87531215,5))
end

function c87531230.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RemoveCounter(tp,COUNTER_BACKUP,1,REASON_EFFECT)
end

function c87531230.double_val(e, c)
    return c:GetCounter(COUNTER_DOUBLE)
end

function c87531230.fly_target(e, c)
    return c:GetCounter(COUNTER_FLY) > 0
end

function c87531230.anti_target(e, c)
    return c:GetCounter(COUNTER_ANTI) > 0
end

function c87531230.immortal_target(e, c)
    return c:GetCounter(COUNTER_IMMORTAL) > 0
end

function c87531230.lifelink_op(e, tp, eg, ep, ev, re, r, rp)
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    local dam = Duel.GetBattleDamage(tp)
    if dam > 0 and a and a:GetCounter(COUNTER_LIFELINK) > 0 and a:IsControler(tp) then
        Duel.Recover(tp, dam, REASON_EFFECT)
    end
    if dam > 0 and d and d:GetCounter(COUNTER_LIFELINK) > 0 and d:IsControler(tp) then
        Duel.Recover(tp, dam, REASON_EFFECT)
    end
end

function c87531230.trample_target(e, c)
    return c:GetCounter(COUNTER_TRAMPLE) > 0
end