--暴噬星皇的威胁
local m=89386008
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.drtg)
    e3:SetOperation(cm.drop)
    c:RegisterEffect(e3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+100000000)
    e2:SetCondition(cm.setcon)
    e2:SetTarget(cm.settg)
    e2:SetOperation(cm.setop)
    c:RegisterEffect(e2)
end
function cm.drfilter(c)
    return c:IsSetCard(0xcc30) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.coinfilter(c)
    return c:IsSetCard(0xcc30) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if not g or g:GetCount()==0 then return end
    local flag=g:GetFirst():IsLocation(LOCATION_MZONE)
    Duel.ConfirmCards(1-tp,g)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    Duel.Draw(tp,2,REASON_EFFECT)
    if flag and Duel.IsExistingMatchingCard(cm.coinfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.coinfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function cm.cfilter(c,tp)
    return c:IsSetCard(0xcc30) and c:IsLevelAbove(7) and c:GetControler()==tp
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_DECKBOT)
        c:RegisterEffect(e1)
    end
end
