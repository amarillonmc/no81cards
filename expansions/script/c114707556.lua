function c114707556.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,114707556)
    e1:SetTarget(c114707556.target)
    e1:SetOperation(c114707556.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,114707557)
    e3:SetTarget(c114707556.thtg)
    e3:SetOperation(c114707556.thop)
    c:RegisterEffect(e3)
end
function c114707556.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c114707556.thfilter1(c)
    return c:IsSetCard(0xc6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c114707556.thfilter2(c)
    return c:IsSetCard(0xc6) and c:IsType(TYPE_PENDULUM)
end
function c114707556.thfilter3(c,e,tp)
    return c:IsSetCard(0xc6) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false)
end
function c114707556.thfilter4(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c114707556.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    local g1=Duel.GetMatchingGroup(c114707556.thfilter1,tp,LOCATION_DECK,0,nil)
    if ct>=1 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg1,REASON_EFFECT)
    end
    local g2=Duel.GetMatchingGroup(c114707556.thfilter2,tp,LOCATION_DECK,0,nil)
    if ct>=2 and g2:GetCount()>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(114707556,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.MoveToField(sg2:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
    local g3=Duel.GetMatchingGroup(c114707556.thfilter3,tp,LOCATION_DECK,0,nil,e,tp)
    if ct>=3 and g3:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg3=g3:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg3,nil,tp,tp,false,false,POS_FACEUP)
    end
    local g4=Duel.GetMatchingGroup(c114707556.thfilter4,tp,LOCATION_DECK,0,nil)
    if ct==4 and g4:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg4=g4:Select(tp,1,1,nil)
        Duel.SendtoHand(sg4,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg4)
    end
end
function c114707556.desfilter(c,ft)
    return ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
end
function c114707556.spfilter(c,e,tp)
    return c:IsSetCard(0xc6) and not c:IsCode(114707556) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false)
end
function c114707556.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local n=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        return Duel.IsExistingTarget(c114707556.desfilter,tp,LOCATION_ONFIELD,0,1,nil,n) and Duel.IsExistingMatchingCard(c114707556.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tg=Duel.SelectTarget(tp,c114707556.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,n)
    n=n-1
    if Duel.IsExistingTarget(c114707556.desfilter,tp,LOCATION_ONFIELD,0,1,tg,n) and Duel.GetMatchingGroup(c114707556.spfilter,tp,LOCATION_DECK,0,nil,e,tp):GetClassCount(Card.GetCode)>=2 and Duel.SelectYesNo(tp,aux.Stringid(114707556,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        tg:Merge(Duel.SelectTarget(tp,c114707556.desfilter,tp,LOCATION_ONFIELD,0,1,1,tg,n))
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,tg:GetCount(),tp,LOCATION_DECK)
end
function c114707556.thop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ct=Duel.Destroy(dg,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(c114707556.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if ct==0 or g:GetCount()==0 then return end
    if ct>g:GetClassCount(Card.GetCode) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=g:Select(tp,1,1,nil)
    if ct==2 then
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g1:Merge(g:Select(tp,1,1,nil))
    end
    Duel.SpecialSummon(g1,nil,tp,tp,false,false,POS_FACEUP)
end