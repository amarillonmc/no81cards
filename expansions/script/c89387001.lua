--青色眼睛的假身
local m=89387001
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(cm.tgtg)
    e2:SetValue(cm.imvalue)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.matfilter(c)
    return c:IsLinkAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsLinkType(TYPE_TUNER)
end
function cm.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0xdd)
end
function cm.imvalue(e,re)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.cfilter(c)
    return c:GetSequence()<5 and not c:IsSetCard(0xdd)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter1(c,e,tp,zone)
    return c:IsSetCard(0xdd) and c:GetLevel()>0 and c:IsAbleToRemove() and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone,c)
end
function cm.filter2(c,e,tp,zone,tc)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==1 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone,Group.FromCards(tc,c))
end
function cm.filter3(c,e,tp,zone,g)
    return c:GetLevel()==g:GetSum(Card.GetLevel) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c,zone)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLinkedZone()) end
    local zone=e:GetHandler():GetLinkedZone()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone,g1:GetFirst())
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()<2 or Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)<2 then return end
    local zone=e:GetHandler():GetLinkedZone()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone,sg)
    if not g1 or g1:GetCount()==0 then return end
    Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
    g1:GetFirst():CompleteProcedure()
end
