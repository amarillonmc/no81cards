--//雷兽窟//
local s,id=GetID()
function s.initial_effect(c)

    -- 激活
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    -- 效果①：星渊虫群怪兽效果变成快速效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(id)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    c:RegisterEffect(e2)
    
    -- 效果②：从除外区回到卡组并破坏卡片
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCountLimit(1,id)
    e3:SetCondition(s.con)
    e3:SetCost(s.cost)
    e3:SetTarget(s.target)
    e3:SetOperation(s.operation)
    c:RegisterEffect(e3)
end

-- 效果②条件：在除外区表侧表示且不是送去墓地的回合
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsFaceup() and not c:IsReason(REASON_RULE) and c:GetTurnID()~=Duel.GetTurnCount()
end

-- 效果②代价：这张卡回到卡组
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

-- 效果②：选择除外的星渊虫群卡回到卡组
function s.tdfilter(c)
    return c:IsSetCard(0x890) and c:IsAbleToDeck() and c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    local xg=nil
    if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xg=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,xg) and g:CheckSubGroup(aux.dncheck,2,2) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tg=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,xg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REMOVED)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    if sg then
        if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA)
            and tc:IsRelateToEffect(e) then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end