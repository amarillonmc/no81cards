--黙示録の預言者　ルシファー
local m=22520006
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(cm.thcost1)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(m)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetTargetRange(1,0)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(cm.regcon)
    e3:SetOperation(cm.regop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(cm.regcon)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)
end
function cm.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
    return c:IsSetCard(0xec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleDeck(tp)
        local tg=sg:Select(1-tp,1,1,nil)
        local tc=tg:GetFirst()
        if tc:IsAbleToHand() then
            tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            sg:RemoveCard(tc)
        end
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsCode(22520011)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(3000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE)
    c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xec1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
