--災厄の火－セントエルモ
local m=22520008
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.condition)
    e3:SetOperation(cm.cactivate)
    c:RegisterEffect(e3)
end
function cm.tgfilter(c)
    return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xec1) or aux.IsCodeListed(c,22520013) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return tp~=Duel.GetTurnPlayer() and bit.band(ph,PHASE_MAIN2+PHASE_END)==0 and Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetRace)>=2
end
function cm.cactivate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetRace)<2 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(0,1)
    Duel.RegisterEffect(e1,tp)
end
