--机怪巨兵 「PTOLEMAEUS」
local m=89388016
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2)
    c:EnableReviveLimit()
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.mttg)
    e2:SetOperation(cm.mtop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,m)
    e3:SetCost(cm.spcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
end
function cm.mfilter(c,xyzc)
    return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsXyzLevel(xyzc,4) or c:IsSetCard(0xcc21) and c:GetLevel()>0)
end
function cm.mtfilter(c)
    return c:IsSetCard(0xcc21)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
    if not g or g:GetCount()==0 then return end
    Duel.Overlay(c,g)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,3,REASON_COST) end
    c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function cm.tgfilter(c)
    return c:IsSetCard(0xcc21) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.filter(c,e,tp)
    local t
    if c:IsType(TYPE_FUSION) then t=SUMMON_TYPE_FUSION end
    if c:IsType(TYPE_SYNCHRO) then t=SUMMON_TYPE_SYNCHRO end
    if c:IsType(TYPE_LINK) then t=SUMMON_TYPE_LINK end
    return c:IsSetCard(0xcc21) and t and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,t,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,2,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
    if not g or g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if not sg or sg:GetCount()==0 then return end
    local tc=sg:GetFirst()
    local t
    if tc:IsType(TYPE_FUSION) then t=SUMMON_TYPE_FUSION end
    if tc:IsType(TYPE_SYNCHRO) then t=SUMMON_TYPE_SYNCHRO end
    if tc:IsType(TYPE_LINK) then t=SUMMON_TYPE_LINK end
    if Duel.SpecialSummonStep(tc,t,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(2600)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc:CompleteProcedure()
    end
    Duel.SpecialSummonComplete()
end
