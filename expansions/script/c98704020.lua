--真帝机的领域
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704020
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --extra summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetTargetRange(LOCATION_HAND,0)
    e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetValue(0x1)
    c:RegisterEffect(e2)
    --decrease tribute
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DECREASE_TRIBUTE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_HAND,0)
    e3:SetCountLimit(1,m)
    e3:SetValue(0x1)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)
    --cannot spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetRange(LOCATION_FZONE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(0,1)
    e5:SetCondition(cm.discon)
    e5:SetTarget(cm.splimit)
    c:RegisterEffect(e5)
    --search and to grave
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,2))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCountLimit(1,m+100)
    e6:SetCost(aux.bfgcost)
    e6:SetTarget(cm.thtg)
    e6:SetOperation(cm.thop)
    c:RegisterEffect(e6)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function cm.filter(c)
    return mqt.ismqt(c) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.splimit(e,c)
    return not c:IsSummonableCard()
end
function cm.cfilter(c)
    return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.discon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and not Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.thfilter(c)
    return mqt.ismqt(c) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleDeck(tp)
        local tg=sg:RandomSelect(1-tp,1)
        local tc=tg:GetFirst()
        if tc:IsAbleToHand() then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            sg:RemoveCard(tc)
        end
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
