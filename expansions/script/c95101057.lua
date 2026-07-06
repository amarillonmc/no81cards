--黑之斩击
--卡号：95101057
--类型：速攻魔法（TYPE_QUICKPLAY + TYPE_SPELL = 65538）
--效果概述：
--  这个卡名在规则上也当作「黑之裁判」卡使用，这个卡名的①②的效果1回合只能有1次使用其中任意1个。
--  ①：把自己场上任意数量的罪孽指示物取除，以那个数量的对方场上的卡为对象才能发动。那些卡回到持有者卡组。
--  ②：自己的主要阶段，把自己场上1张「黑之裁判」永续陷阱卡送去墓地才能发动。墓地的这张卡在自己场上盖放。

function c95101057.initial_effect(c)
    -- 效果①：取除罪孽指示物，对象卡回卡组
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(95101057,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,95101057)
    e1:SetCost(c95101057.cost1)
    e1:SetTarget(c95101057.tg1)
    e1:SetOperation(c95101057.op1)
    c:RegisterEffect(e1)
    
    -- 效果②：把1张「黑之裁判」永续陷阱送去墓地，墓地的这张卡盖放
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95101057,1))
    e2:SetCategory(CATEGORY_SSET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,95101057)
    e2:SetCost(c95101057.cost2)
    e2:SetTarget(c95101057.tg2)
    e2:SetOperation(c95101057.op2)
    c:RegisterEffect(e2)
end

function c95101057.get_counter_count(tp)
    local ct=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(g) do
        ct=ct+tc:GetCounter(0xbbb)
    end
    return ct
end

function c95101057.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=c95101057.get_counter_count(tp)
    local opp_ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    local maxct=math.min(ct,13,opp_ct)
    if chk==0 then
        e:SetLabel(maxct)
        return maxct>=1
    end
    -- 选择要取除的数量（1~maxct）
    local t={}
    for i=1,maxct do table.insert(t,i) end
    local ann=Duel.AnnounceNumber(tp,table.unpack(t))
    c95101057.remove_counter(tp,ann)
    e:SetLabel(ann)
end

function c95101057.remove_counter(tp,ct)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    local removed=0
    for tc in aux.Next(g) do
        local ctc=tc:GetCounter(0xbbb)
        if ctc>0 then
            local rct=math.min(ctc,ct-removed)
            tc:RemoveCounter(tp,0xbbb,rct,REASON_COST)
            removed=removed+rct
            if removed>=ct then break end
        end
    end
end

function c95101057.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=e:GetLabel()
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
    if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function c95101057.op1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if g then
        local tg=g:Filter(Card.IsRelateToEffect,nil,e)
        if tg:GetCount()>0 then
            Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end

function c95101057.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95101057.tgfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c95101057.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function c95101057.tgfilter(c)
    return c:IsSetCard(0xbbb) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end

function c95101057.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function c95101057.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SSet(tp,c)
    end
end
