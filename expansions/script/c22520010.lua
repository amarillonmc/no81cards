--罪の穢れ－セルリウム
local m=22520010
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,22520013)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.rttg)
    e2:SetOperation(cm.rtop)
    c:RegisterEffect(e2)
end
function cm.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xec1) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22520013,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22520013,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then
        local token=Duel.CreateToken(tp,22520013)
        Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e3:SetTargetRange(1,0)
        e3:SetTarget(cm.sumlimit)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e3,true)
        Duel.SpecialSummonComplete()
    end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA)
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
    if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)>0 and g:GetFirst():IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22520013,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        local token=Duel.CreateToken(tp,22520013)
        Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e3:SetTargetRange(1,0)
        e3:SetTarget(cm.sumlimit)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e3,true)
        Duel.SpecialSummonComplete()
    end
end
