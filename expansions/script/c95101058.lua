--黑之裁判<尖兵>琳达梅尔
--卡号：95101058
--类型：效果怪兽（TYPE_EFFECT + TYPE_MONSTER = 33）
--属性：暗（ATTRIBUTE_DARK = 32）
--种族：天使族（RACE_FAIRY = 4）
--ATK/DEF：3500/0
--等级：8
--效果概述：
--  这个卡名的②的效果1回合只能使用1次。
--  ①：有怪兽被送去对方墓地的场合才能发动。手卡·墓地的这张卡当作永续陷阱卡使用在自己的魔法与陷阱区域表侧表示放置。那之后，可以从手卡·卡组把1张「黑之裁判」在场地区域表侧表示放置。
--  ②：自己的主要阶段，这张卡是当作永续陷阱卡使用的场合，支付2000基本分或把场上最多5个罪孽指示物取除才能发动。这张卡特殊召唤。那之后，可以选对方场上1张卡送去墓地。把5个罪孽指示物取除的场合，这个效果在对方的回合也可以发动。

function c95101058.initial_effect(c)
    -- 效果①：有怪兽被送去对方墓地时，手卡·墓地的这张卡当作永续陷阱放置，然后场放置1张「黑之裁判」
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(95101058,0))
    e1:SetCategory(0)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,95101058)
    e1:SetCondition(c95101058.con1)
    e1:SetTarget(c95101058.tg1)
    e1:SetOperation(c95101058.op1)
    c:RegisterEffect(e1)
    
    -- 效果②：当作永续陷阱使用时，支付2000LP或取除最多5个罪孽指示物特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95101058,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,95101058+1)
    e2:SetCondition(c95101058.con2)
    e2:SetCost(c95101058.cost2)
    e2:SetTarget(c95101058.tg2)
    e2:SetOperation(c95101058.op2)
    c:RegisterEffect(e2)
    -- 对方回合也可以发动（取除5个罪孽指示物时）
    local e2b=e2:Clone()
    e2b:SetType(EFFECT_TYPE_QUICK_O)
    e2b:SetCode(EVENT_FREE_CHAIN)
    e2b:SetCondition(c95101058.con2b)
    e2b:SetCost(c95101058.cost2b)
    c:RegisterEffect(e2b)
end

function c95101058.con1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(function(c) return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) end,1,nil)
end

function c95101058.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function c95101058.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    -- 当作永续陷阱卡使用在魔陷区域表侧表示放置
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    -- 那之后，自己场地区域没有「黑之裁判」（95101055）的场合，可以从手卡·卡组把1张「黑之裁判」在场地区域表侧表示放置
    if not Duel.IsExistingMatchingCard(c95101058.isfield,tp,LOCATION_FZONE,0,1,nil) then
        if Duel.IsExistingMatchingCard(c95101058.fieldfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(95101058,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
                local g=Duel.SelectMatchingCard(tp,c95101058.fieldfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
                if g:GetCount()>0 then
                    local tc=g:GetFirst()
                    Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
                end
            end
        end
    end

function c95101058.isfield(c)
    return c:IsCode(95101055)
end
end

function c95101058.fieldfilter(c)
    return c:IsSetCard(0xbbb) and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL)
end

function c95101058.con2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and Duel.IsMainPhase() and Duel.GetTurnPlayer()==tp
end

function c95101058.con2b(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and Duel.IsMainPhase() and Duel.GetTurnPlayer()~=tp
end

function c95101058.get_counter_count(tp)
    local ct=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(g) do
        ct=ct+tc:GetCounter(0xbbb)
    end
    return ct
end

function c95101058.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    -- 自己主阶段：取除1个指示物，或支付2000LP代替1个
    if chk==0 then
        return Duel.CheckLPCost(tp,2000) or c95101058.get_counter_count(tp)>=1
    end
    local ct=c95101058.get_counter_count(tp)
    local b1=Duel.CheckLPCost(tp,2000)
    local b2=ct>=1
    local opts={}
    local vals={}
    if b1 then
        table.insert(opts,aux.Stringid(95101058,3))
        table.insert(vals,0)
    end
    if b2 then
        table.insert(opts,aux.Stringid(95101058,4))
        table.insert(vals,1)
    end
    local opt=Duel.SelectOption(tp,table.unpack(opts))
    local val=vals[opt+1]
    if val==0 then
        Duel.PayLPCost(tp,2000)
    else
        c95101058.remove_counter(tp,1)
    end
end

function c95101058.cost2b(e,tp,eg,ep,ev,re,r,rp,chk)
    -- 对方主阶段：取除5个指示物，或支付10000LP代替5个（每1个2000LP）
    if chk==0 then return Duel.CheckLPCost(tp,10000) or c95101058.get_counter_count(tp)>=5 end
    local ct=c95101058.get_counter_count(tp)
    local b1=Duel.CheckLPCost(tp,10000)
    local b5=ct>=5
    local opts={}
    local vals={}
    if b1 then
        table.insert(opts,aux.Stringid(95101058,3))
        table.insert(vals,0)
    end
    if b5 then
        table.insert(opts,aux.Stringid(95101058,5))
        table.insert(vals,5)
    end
    local opt=Duel.SelectOption(tp,table.unpack(opts))
    local val=vals[opt+1]
    if val==0 then
        Duel.PayLPCost(tp,10000)
    else
        c95101058.remove_counter(tp,5)
    end
end

function c95101058.remove_counter(tp,ct)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    local removed=0
    for tc in aux.Next(g) do
        local ctc=tc:GetCounter(0xbbb)
        if ctc>0 then
            local rct=math.min(ctc,ct-removed)
            tc:RemoveCounter(tp,0xbbb,rct,REASON_EFFECT)
            removed=removed+rct
            if removed>=ct then break end
        end
    end
end

function c95101058.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end

function c95101058.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    -- 这张卡特殊召唤
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        -- 那之后，选对方场上1张卡送去墓地
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end
