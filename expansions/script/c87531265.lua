-- 伏匿之丝 放射性蜘蛛

local COUNTER_DEATHTOUCH = 0x16fd
local ALSTA_CARD = 87531235
local EGG_CARD = 87531225

function c87531265.initial_effect(c)
    c:EnableCounterPermit(COUNTER_DEATHTOUCH)

    -- ①效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531265,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_HANDES+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,87531265)
    e1:SetCondition(c87531265.con_attack)
    e1:SetTarget(c87531265.tg1)
    e1:SetOperation(c87531265.op1)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531265,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_HANDES+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,87531265)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
    e2:SetCondition(c87531265.con_target)
    e2:SetTarget(c87531265.tg1)
    e2:SetOperation(c87531265.op1)
    c:RegisterEffect(e2)

    -- ②效果
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(87531265,3))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,87531265+100)
    e3:SetTarget(c87531265.tg2)
    e3:SetOperation(c87531265.op2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
end

function c87531265.IsAlastaAvailable()
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

function c87531265.con_attack(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end

function c87531265.con_target(e,tp,eg,ep,ev,re,r,rp)
    local has_alasta=c87531265.IsAlastaAvailable()
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

function c87531265.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local loc=c:GetLocation()
    local can_sp=(loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    if chk==0 then
        return can_sp
    end
    local has_target=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
    local place_death=false
    if has_target then
        place_death=Duel.SelectYesNo(tp,aux.Stringid(87531265,1))
    end
    if place_death then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
        local cost_type=0
        local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
        local b2=Duel.CheckLPCost(tp,1000)
        if b1 and b2 then
            cost_type=Duel.SelectOption(tp,aux.Stringid(87531265,2),aux.Stringid(87531265,3))
        elseif b1 then
            cost_type=0
        elseif b2 then
            cost_type=1
        else
            place_death=false
        end
        e:SetLabel(cost_type)
    else
        e:SetProperty(0)
        e:SetLabel(-1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c87531265.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local loc=c:GetLocation()
    if (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            c:RegisterFlagEffect(87531265,RESET_EVENT+RESETS_STANDARD,0,1)
            if e:GetLabel()~=-1 then
                local tc=Duel.GetFirstTarget()
                if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                    local ct=e:GetLabel()
                    if ct==0 then
                        Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
                    else
                        Duel.PayLPCost(tp,1000)
                    end
                    if tc:IsCanAddCounter(COUNTER_DEATHTOUCH,1) then
                        tc:AddCounter(COUNTER_DEATHTOUCH,1,REASON_EFFECT)
                        c87531265.register_death_touch(tc)
                    end
                end
            end
        end
    end
end

function c87531265.register_death_touch(c)
    -- 战斗破坏效果（不可无效）
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCondition(c87531265.dt_battlecon)
    e1:SetOperation(c87531265.dt_battleop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1,true)

    -- 效果破坏（守备力下降时，不可无效）
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c87531265.dt_effectcon)
    e2:SetOperation(c87531265.dt_effectop)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2,true)
end

function c87531265.dt_battlecon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetCounter(COUNTER_DEATHTOUCH)>0 and c:GetBattleTarget()~=nil
end

function c87531265.dt_battleop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
        Duel.Destroy(bc,REASON_EFFECT)
    end
end

function c87531265.dt_effectcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetCounter(COUNTER_DEATHTOUCH)==0 then return false end
    local te=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
    if not te then return false end
    if te:GetHandler()~=c then return false end
    if not (te:GetCategory() and bit.band(te:GetCategory(),CATEGORY_DEFCHANGE)~=0) then return false end
    local tg=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS)
    if not tg then return false end
    if tg:IsExists(function(tc) return tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) end,1,nil) then
        return true
    end
    return false
end

function c87531265.dt_effectop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS)
    if not tg then return end
    local g=tg:Filter(function(tc) return tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) end,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end

function c87531265.thfilter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c87531265.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c87531265.thfilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c87531265.exgfilter(c, mg, mc)
    return mg:CheckSubGroup(c87531265.exgselect, 1, mg:GetCount(), c, mc)
end
function c87531265.exgselect(g, exc, mc)
    return g:IsContains(mc) and exc:IsXyzSummonable(g, g:GetCount(), g:GetCount())
end

function c87531265.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c87531265.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end

    local flag1=c:GetFlagEffect(87531265)>0
    local flag2=c:GetFlagEffect(EGG_CARD)>0
    if not (flag1 or flag2) or not Duel.SelectYesNo(tp,aux.Stringid(87531265,4)) then
        return
    end

    local mg=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)

    local has_xyz = Duel.IsExistingMatchingCard(c87531265.exgfilter, tp, LOCATION_EXTRA, 0, 1, nil, mg, c)

    local linklist = {}
    for sc in aux.Next(Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_EXTRA, 0, nil, TYPE_LINK)) do
        if sc:IsLinkSummonable(nil, nil, nil, c) then
            table.insert(linklist, sc)
        end
    end
    local has_link = #linklist > 0

    local opt = 0
    if has_xyz and has_link then
        opt = Duel.SelectOption(tp, aux.Stringid(87531265,5), aux.Stringid(87531265,6))
    elseif has_xyz then
        opt = 0
    elseif has_link then
        opt = 1
    else
        return
    end

    if opt == 0 then
        local exg = Duel.GetMatchingGroup(c87531265.exgfilter, tp, LOCATION_EXTRA, 0, nil, mg, c)
        if #exg == 0 then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local sc = exg:Select(tp, 1, 1, nil):GetFirst()
        if not sc then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
        local mat = mg:SelectSubGroup(tp, c87531265.exgselect, false, 1, mg:GetCount(), sc, c)
        if mat then
            Duel.XyzSummon(tp, sc, mat)
        end
    else
        if #linklist == 0 then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local sc
        if #linklist == 1 then
            sc = linklist[1]
        else
            local selected = Duel.SelectMatchingCard(tp, function(card) 
                for _, v in ipairs(linklist) do if v==card then return true end end 
                return false 
            end, tp, LOCATION_EXTRA, 0, 1, 1, nil)
            sc = selected:GetFirst()
        end
        if not sc then return end
        Duel.LinkSummon(tp, sc, nil, c)
    end
end