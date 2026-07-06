--黑之裁断
--卡号：95101189
--类型：反击陷阱（TYPE_COUNTER + TYPE_TRAP）
--效果概述：
--  这个卡名在规则上也当作「黑之裁判」卡使用，这个卡名的①②的效果1回合只能有1次使用其中任意1个。
--  ①：怪兽的效果·魔法·陷阱卡发动时，把自己场上3个罪孽指示物取除才能发动。那个发动无效并破坏。
--  ②：自己的主要阶段，把自己场上1张「黑之裁判」永续陷阱卡送去墓地才能发动。墓地的这张卡在自己场上盖放。

function c95101189.initial_effect(c)
    -- 效果①：取除3个罪孽指示物，怪兽/魔法/陷阱卡发动无效并破坏
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(95101189,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCountLimit(1,95101189)
    e1:SetCost(c95101189.cost1)
    e1:SetTarget(c95101189.tg1)
    e1:SetOperation(c95101189.op1)
    c:RegisterEffect(e1)
    
    -- 效果②：把1张「黑之裁判」永续陷阱送去墓地，墓地的这张卡盖放
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95101189,1))
    e2:SetCategory(CATEGORY_SSET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,95101189)
    e2:SetCost(c95101189.cost2)
    e2:SetTarget(c95101189.tg2)
    e2:SetOperation(c95101189.op2)
    c:RegisterEffect(e2)
end

function c95101189.get_counter_count(tp)
    local ct=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(g) do
        ct=ct+tc:GetCounter(0xbbb)
    end
    return ct
end

function c95101189.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return c95101189.get_counter_count(tp)>=3 end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    local removed=0
    for tc in aux.Next(g) do
        local ctc=tc:GetCounter(0xbbb)
        if ctc>0 and removed<3 then
            local rct=math.min(ctc,3-removed)
            tc:RemoveCounter(tp,0xbbb,rct,REASON_COST)
            removed=removed+rct
            if removed>=3 then break end
        end
    end
end

function c95101189.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsChainNegatable(ev) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end

function c95101189.op1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) then
        if re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(eg,REASON_EFFECT)
        end
    end
end

function c95101189.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95101189.tgfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c95101189.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function c95101189.tgfilter(c)
    return c:IsSetCard(0xbbb) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end

function c95101189.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function c95101189.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SSet(tp,c)
    end
end