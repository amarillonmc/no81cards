--//进化腔//
local s,id=GetID()
function s.initial_effect(c)

    -- 激活
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    -- 效果①：对方不能连锁星渊虫群怪兽的效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(s.chainop)
    c:RegisterEffect(e2)
    
    -- 效果②：从除外区回到卡组并回收怪兽
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCountLimit(1,id)
    e3:SetCondition(s.con)
    e3:SetCost(s.cost)
    e3:SetTarget(s.target)
    e3:SetOperation(s.operation)
    c:RegisterEffect(e3)
end

-- 效果②条件：在除外区表侧表示
function s.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup()
end

-- 效果②代价：这张卡回到卡组
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

-- 效果①：对方不能连锁星渊虫群怪兽的效果
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsSetCard(0x890) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
        Duel.SetChainLimit(s.chainlm)
    end
end

function s.chainlm(e,rp,tp)
    return tp==rp
end

-- 效果②：选择除外的星渊虫群卡回到卡组
function s.tdfilter(c)
    return c:IsSetCard(0x890) and c:IsAbleToDeck() and c:IsFaceup()
end

-- 效果②：选择加入手卡的星渊虫群怪兽
function s.thfilter(c)
    return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
    local xg=nil
    if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xg=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,xg) and g:CheckSubGroup(aux.dncheck,2,2) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,xg)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
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
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end