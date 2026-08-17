-- 凄陌寒昼·绝对零度
local s,id,o=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --①效果：回收墓地·除外的最多5张本家卡，之后抽1张
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)

    --②效果：对方场上霜冻指示物合计6个以上时，对方魔陷效果无效化
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(s.discon)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)

    --③效果：被解放时表侧放置回魔陷区
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_RELEASE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetTarget(s.reltg)
    e3:SetOperation(s.relop)
    c:RegisterEffect(e3)
end

--①效果过滤：本家墓地·除外的可回卡组卡
function s.thfilter(c)
    return c:IsSetCard(0x3f15) and c:IsFaceupEx() and c:IsAbleToDeck()
end

--①效果目标：取对象，且必须能抽1张
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) end
    if chk==0 then
        return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
            and Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

--①效果操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end

--②效果条件：对方场上霜冻指示物合计≥6，且当前处理的是对方魔陷效果
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetHandlerPlayer()
    local ct=Duel.GetCounter(p,0,LOCATION_MZONE,0x1f15)
    if ct<6 then return false end
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==1-p and re:IsActivated()
end

--②效果操作：无效化
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.NegateEffect(ev)
end

--③效果目标检查：魔陷区空位
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

--③效果操作：表侧放置回魔陷区
function s.relop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end