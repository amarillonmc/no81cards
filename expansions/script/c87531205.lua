-- 伏匿之丝 末日编蛛
local COUNTER_SHELTER = 0x18fd
local ALSTA_CARD = 87531235 

function c87531205.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SHELTER)

    -- ①效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531205,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,87531205)
    e1:SetCondition(c87531205.con_attack)
    e1:SetTarget(c87531205.tg1)
    e1:SetOperation(c87531205.op1)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531205,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,87531205)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
    e2:SetCondition(c87531205.con_target)
    e2:SetTarget(c87531205.tg1)
    e2:SetOperation(c87531205.op1)
    c:RegisterEffect(e2)

    -- ②效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531205,3))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,87531205+100)
    e3:SetTarget(c87531205.tg2)
    e3:SetOperation(c87531205.op2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)

    local e_shelter=Effect.CreateEffect(c)
    e_shelter:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_shelter:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e_shelter:SetOperation(c87531205.shelterop)
    e_shelter:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    Duel.RegisterEffect(e_shelter,0)
end

function c87531205.IsAlastaAvailable()
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

function c87531205.con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end

function c87531205.con_target(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local has_alasta=c87531205.IsAlastaAvailable()
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

function c87531205.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local loc=c:GetLocation()
    local can_sp=(loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    if chk==0 then
        return can_sp
    end
    local op=0
    if loc==LOCATION_HAND then
        local has_target=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        if has_target then
            op=Duel.SelectOption(tp,aux.Stringid(87531205,1),aux.Stringid(87531205,2)) 
        else
            op=0
        end
    else
        op=0
    end
    e:SetLabel(op)
    if op==1 then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
    else
        e:SetProperty(0)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c87531205.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local loc=c:GetLocation()
    if (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            c:RegisterFlagEffect(87531205,RESET_EVENT+RESETS_STANDARD,0,1)
            local op=e:GetLabel()
            if loc==LOCATION_HAND and op==1 then
                local tc=Duel.GetFirstTarget()
                if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                    if tc:IsCanAddCounter(COUNTER_SHELTER,1) then
                        tc:AddCounter(COUNTER_SHELTER,1,REASON_EFFECT)
                    end
                end
            end
        end
    end
end

function c87531205.spfilter(c,e,tp)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87531205.thfilter(c)
    return c:IsSetCard(0xf8a) and c:IsAbleToHand()
end

function c87531205.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local special_flag=c:GetFlagEffect(87531205)>0  
    local b1=Duel.IsExistingMatchingCard(c87531205.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    local b2=Duel.IsExistingMatchingCard(c87531205.thfilter,tp,LOCATION_GRAVE,0,1,nil)
    if chk==0 then
        return b1 or b2
    end
    local ops={}
    local texts={}
    if b1 then
        table.insert(ops,1)
        table.insert(texts,aux.Stringid(87531205,4))
    end
    if b2 then
        table.insert(ops,2)
        table.insert(texts,aux.Stringid(87531205,5))
    end
    local double_available = b1 and b2 and special_flag
    if double_available then
        table.insert(ops,3)
        table.insert(texts,aux.Stringid(87531205,6))
    end

    local op_index
    if #ops==1 then
        op_index=1
    else
        op_index=Duel.SelectOption(tp,table.unpack(texts))+1
    end
    local selected=ops[op_index]
    e:SetLabel(selected)

    if selected==1 or selected==3 then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
    end
    if selected==2 or selected==3 then
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    end
end

function c87531205.op2(e,tp,eg,ep,ev,re,r,rp)
    local selected=e:GetLabel()
    if selected==1 or selected==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87531205.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
    if selected==2 or selected==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c87531205.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function c87531205.shelterop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not a or not d then return end
    local function process(mon)
        if mon and mon:GetCounter(COUNTER_SHELTER)>0 then
            local owner=mon:GetControler()
            local dam=Duel.GetBattleDamage(owner)
            if dam>0 then
                Duel.ChangeBattleDamage(owner,0)
                mon:RemoveCounter(owner,COUNTER_SHELTER,1,REASON_EFFECT)
            end
        end
    end
    process(a)
    process(d)
end