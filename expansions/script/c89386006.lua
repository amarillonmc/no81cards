--暴噬星皇·影界鱼
local m=89386006
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.cointg)
    e1:SetOperation(cm.coinop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m+100000000)
    e3:SetCost(cm.drcost)
    e3:SetTarget(cm.drtg)
    e3:SetOperation(cm.drop)
    c:RegisterEffect(e3)
end
function cm.coinfilter(c)
    return c:IsSetCard(0xcc30) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function cm.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.coinfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.coinfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.drfilter(c)
    return c:IsSetCard(0xcc30) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
