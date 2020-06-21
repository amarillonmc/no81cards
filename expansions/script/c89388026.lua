--Uni☆ties 深海歌剧院
local m=89388026
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcc22))
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(cm.drtg)
    e3:SetOperation(cm.drop)
    c:RegisterEffect(e3)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetOperation(cm.regop)
    c:RegisterEffect(e1)
end
function cm.drfilter(c)
    return c:IsSetCard(0xcc22) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,63,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-tp,g)
        local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if rp==1-tp and c:IsReason(REASON_EFFECT) then
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetTarget(cm.thtg)
        e1:SetOperation(cm.thop)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function cm.filter(c)
    return c:IsSetCard(0xcc22) and c:IsAbleToHand()
end
function cm.filter2(c,tp)
    return c:IsCode(m) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
        if not sg or sg:GetCount()==0 then return end
        local tc=sg:GetFirst()
        Duel.BreakEffect()
        local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
