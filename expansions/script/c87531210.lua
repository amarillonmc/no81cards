-- 伏匿之丝 链网冥蛛
local COUNTER_ATKDEF = 0x17fd
local COUNTER_DEATHTOUCH = 0x16fd
local ALSTA_CARD = 87531235
local EGG_CARD = 87531225 

function c87531210.initial_effect(c)
    c:EnableCounterPermit(COUNTER_ATKDEF)

    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531210,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,87531210)
    e1:SetCondition(c87531210.con_attack)
    e1:SetTarget(c87531210.tg1)
    e1:SetOperation(c87531210.op1)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531210,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,87531210)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
    e2:SetCondition(c87531210.con_target)
    e2:SetTarget(c87531210.tg1)
    e2:SetOperation(c87531210.op1)
    c:RegisterEffect(e2)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531210,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_DEFCHANGE) 
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,87531210+100)
    e3:SetTarget(c87531210.tg2)
    e3:SetOperation(c87531210.op2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)

    local e_atk_self=Effect.CreateEffect(c)
    e_atk_self:SetType(EFFECT_TYPE_SINGLE)
    e_atk_self:SetCode(EFFECT_UPDATE_ATTACK)
    e_atk_self:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF)*400 end)
    c:RegisterEffect(e_atk_self)
    local e_def_self=Effect.CreateEffect(c)
    e_def_self:SetType(EFFECT_TYPE_SINGLE)
    e_def_self:SetCode(EFFECT_UPDATE_DEFENSE)
    e_def_self:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF)*400 end)
    c:RegisterEffect(e_def_self)
end

function c87531210.add_permanent_effect(card, target)
    local e_atk=Effect.CreateEffect(card)
    e_atk:SetType(EFFECT_TYPE_SINGLE)
    e_atk:SetCode(EFFECT_UPDATE_ATTACK)
    e_atk:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF)*400 end)
    e_atk:SetReset(RESET_EVENT+RESETS_STANDARD)
    target:RegisterEffect(e_atk, true)
    local e_def=Effect.CreateEffect(card)
    e_def:SetType(EFFECT_TYPE_SINGLE)
    e_def:SetCode(EFFECT_UPDATE_DEFENSE)
    e_def:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF)*400 end)
    e_def:SetReset(RESET_EVENT+RESETS_STANDARD)
    target:RegisterEffect(e_def, true)
end

function c87531210.HasAlasta()
    local field_g = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, ALSTA_CARD)
    for tc in aux.Next(field_g) do
        if tc:IsFaceup() and not tc:IsDisabled() then
            return true
        end
    end
    if Duel.IsExistingMatchingCard(Card.IsCode, 0, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil, ALSTA_CARD) then
        return true
    end
    return false
end

function c87531210.con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end

function c87531210.con_target(e,tp,eg,ep,ev,re,r,rp)
    local has_alasta=c87531210.HasAlasta()
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

function c87531210.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local loc=c:GetLocation()
    local can_sp=(loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    if chk==0 then
        return can_sp
    end
    local op=0
    if loc==LOCATION_GRAVE then
        local has_target=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        if has_target and Duel.SelectYesNo(tp,aux.Stringid(87531210,2)) then
            op=1
            e:SetProperty(EFFECT_FLAG_CARD_TARGET)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        else
            op=0
            e:SetProperty(0)
        end
    else
        op=0
        e:SetProperty(0)
    end
    e:SetLabel(op)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    if op==1 then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
        Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
    end
end

function c87531210.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local loc=c:GetLocation()
    if (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            c:RegisterFlagEffect(87531210,RESET_EVENT+RESETS_STANDARD,0,1)
            local op=e:GetLabel()
            if loc==LOCATION_GRAVE and op==1 then
                local tc=Duel.GetFirstTarget()
                if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                    local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
                    if rg:GetCount()==0 then return end
                    local remove_count=0
                    local opt={}
                    table.insert(opt,aux.Stringid(87531210,3))
                    if rg:GetCount()>=1 then table.insert(opt,aux.Stringid(87531210,4)) end
                    if rg:GetCount()>=2 then table.insert(opt,aux.Stringid(87531210,5)) end
                    local sel=Duel.SelectOption(tp,table.unpack(opt))
                    if sel==0 then
                        remove_count=0
                    elseif sel==1 then
                        remove_count=1
                    else
                        remove_count=2
                    end
                    if remove_count==0 then return end
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                    local sg=rg:Select(tp,remove_count,remove_count,nil)
                    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
                    
                    -- 修改点：分别处理每次除外
                    local total_self_put = 0
                    for i=1,remove_count do
                        local ann={1,2,3}
                        local put=Duel.AnnounceNumber(tp,table.unpack(ann))
                        if put>0 then
                            tc:AddCounter(COUNTER_ATKDEF,put,REASON_EFFECT)
                            if tc:GetFlagEffect(87531210+1)==0 then
                                tc:RegisterFlagEffect(87531210+1, RESET_EVENT+RESETS_STANDARD, 0, 1)
                                c87531210.add_permanent_effect(c, tc)
                            end
                            total_self_put = total_self_put + (3 - put)
                        end
                    end
                    if total_self_put>0 then
                        c:AddCounter(COUNTER_ATKDEF,total_self_put,REASON_EFFECT)
                    end
                end
            end
        end
    end
end

function c87531210.thfilter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function c87531210.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local special_flag = c:GetFlagEffect(87531210)>0 or (re and re:GetHandler():IsCode(EGG_CARD))
    if chk==0 then
        return Duel.IsExistingMatchingCard(c87531210.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK+LOCATION_GRAVE)
    if special_flag then
        e:SetLabel(1)
    else
        e:SetLabel(0)
    end
end

function c87531210.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp, c87531210.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1-tp, g)
    end
    if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil) then
        if Duel.SelectYesNo(tp, aux.Stringid(87531210,6)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
            local tc=Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, 1, nil):GetFirst()
            if not tc then return end
            if c:GetCounter(COUNTER_DEATHTOUCH) > 0 then
                Duel.Destroy(tc, REASON_EFFECT)
                return
            end
            if tc:IsType(TYPE_LINK) then
                Duel.Destroy(tc, REASON_EFFECT)
            else
                local atk=c:GetAttack()
                if atk>0 then
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_UPDATE_DEFENSE)
                    e1:SetValue(-atk)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e1)
                    if tc:GetDefense()<=0 then
                        Duel.Destroy(tc, REASON_EFFECT)
                    end
                end
            end
        end
    end
end