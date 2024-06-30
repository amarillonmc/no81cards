--怅然之魂
local m=89390010
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_REMOVE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.srettg)
    e1:SetOperation(cm.sretop)
    c:RegisterEffect(e1)
end
function cm.srettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.rmfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.spfilter1(c,e,tp,tc)
    return c:IsRace(tc:GetRace()) and not c:IsCode(tc:GetCode()) and c:IsLevelAbove(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sretop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rc=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
    if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,rc) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp,rc)
        if tg:GetCount()<=0 then return end
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
    end
end
