-- 伏匿之丝 捕空蜘蛛
local COUNTER_BACKUP = 0x15fd
local ALSTA_CARD = 87531235
local EGG_CARD = 87531225

function c87531215.initial_effect(c)
    c:EnableCounterPermit(COUNTER_BACKUP)

    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531215,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_HANDES+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,87531215)
    e1:SetCondition(c87531215.con_attack)
    e1:SetTarget(c87531215.tg1)
    e1:SetOperation(c87531215.op1)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531215,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_HANDES+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,87531215)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
    e2:SetCondition(c87531215.con_target)
    e2:SetTarget(c87531215.tg1)
    e2:SetOperation(c87531215.op1)
    c:RegisterEffect(e2)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531215,3))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,87531215+100)
    e3:SetTarget(c87531215.tg2)
    e3:SetOperation(c87531215.op2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
end

function c87531215.IsAlastaAvailable()
    local field_g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ALSTA_CARD)
    for tc in aux.Next(field_g) do
        if tc:IsFaceup() and not tc:IsDisabled() then
            return true
        end
    end
    if Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ALSTA_CARD) then
        return true
    end
    return false
end

function c87531215.con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end

function c87531215.con_target(e,tp,eg,ep,ev,re,r,rp)
    local has_alasta=c87531215.IsAlastaAvailable()
    for i=1, Duel.GetCurrentChain() do
        local te, tgp, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TARGET_CARDS)
        if te and tg then
            if tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then
                return true
            end
            if has_alasta and tg:IsExists(function(tc) return tc:IsControler(tp) and tc:IsLocation(LOCATION_GRAVE) end,1,nil) then
                return true
            end
        end
    end
    return false
end

-- ①效
function c87531215.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local loc=c:GetLocation()
    local can_sp=(loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    if chk==0 then
        return can_sp
    end
    local place_backup=false
    if loc==LOCATION_GRAVE then
        local has_target=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        if has_target then
            place_backup=Duel.SelectYesNo(tp,aux.Stringid(87531215,1))
        end
    end
    if place_backup then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.HintSelection(g) -- 让对方确认
        Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
        local options={}
        if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then
            table.insert(options,aux.Stringid(87531215,2))
        end
        if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,c) then
            table.insert(options,aux.Stringid(87531215,3))
        end
        if #options==0 then
            place_backup=false
        else
            local op_index
            if #options==1 then
                op_index=1
            else
                op_index=Duel.SelectOption(tp,table.unpack(options))+1
            end
            e:SetLabel(op_index)
        end
    else
        e:SetProperty(0)
        e:SetLabel(0)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c87531215.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local loc=c:GetLocation()
    if (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        local op=e:GetLabel()
        local can_sp = true
        if loc==LOCATION_GRAVE and op~=0 then
            local tc=Duel.GetFirstTarget()
            if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                if op==1 then
                    if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then
                        Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
                    else
                        can_sp = false
                    end
                elseif op==2 then
                    if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,c) then
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                        local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,c)
                        if #rg>0 then
                            Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
                        else
                            can_sp = false
                        end
                    else
                        can_sp = false
                    end
                end
                if can_sp then
                    if tc:IsCanAddCounter(COUNTER_BACKUP,1) then
                        tc:AddCounter(COUNTER_BACKUP,1,REASON_EFFECT)
                        RegisterBackupCounterReplace(tc)
                    end
                end
            else
                can_sp = false
            end
        end
        if can_sp then
            if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
                c:RegisterFlagEffect(87531215,RESET_EVENT+RESETS_STANDARD,0,1)
            end
        end
    end
end

function RegisterBackupCounterReplace(card)
    if card:GetFlagEffect(87531215+1000) ~= 0 then return end
    card:RegisterFlagEffect(87531215+1000, RESET_EVENT+RESETS_STANDARD, 0, 1)
    local e_replace=Effect.CreateEffect(card)
    e_replace:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e_replace:SetCode(EFFECT_DESTROY_REPLACE)
    e_replace:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c=e:GetHandler()
        if chk==0 then
            return c:GetCounter(COUNTER_BACKUP)>0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
        end
        return Duel.SelectEffectYesNo(tp, c, aux.Stringid(87531215,5))
    end)
    e_replace:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c=e:GetHandler()
        c:RemoveCounter(tp, COUNTER_BACKUP, 1, REASON_EFFECT)
    end)
    e_replace:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  -- 关键修改：不可无效化
    card:RegisterEffect(e_replace)
end

function c87531215.thfilter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c87531215.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c87531215.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c87531215.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87531215.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end

    local flag1=c:GetFlagEffect(87531215)>0
    local flag2=c:GetFlagEffect(EGG_CARD)>0
    if flag1 or flag2 then
        local dg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
        if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(87531215,4)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=dg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    end
end