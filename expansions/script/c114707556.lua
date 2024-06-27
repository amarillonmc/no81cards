--Emヒキグルミ
function c114707556.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,114707556)
    e1:SetTarget(c114707556.thtg)
    e1:SetOperation(c114707556.thop)
    c:RegisterEffect(e1)
    --swaying gaze
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,10428)
    e2:SetTarget(c114707556.target)
    e2:SetOperation(c114707556.activate)
    c:RegisterEffect(e2)
end

function c114707556.thfilter(c,e,tp)
    return c:IsSetCard(0xc6) and not c:IsCode(114707556) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114707556.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c114707556.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c114707556.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
    local ct=g:GetClassCount(Card.GetCode)
    if ct>2 then ct=2 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
    local dg=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    if ft==1 then
        dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
        local tc=dg:GetFirst()
        if ct==2 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,tc)
            and Duel.SelectYesNo(tp,aux.Stringid(114707556,1)) then
            if tc:IsLocation(LOCATION_MZONE) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,tc)
                dg:Merge(dg2)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,tc)
                dg:Merge(dg2)
            end
        end
    elseif ft==0 then
        dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,ct,nil)
    else
        dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,ct,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,dg:GetCount(),0,0)
end
function c114707556.thop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ct=Duel.Destroy(dg,REASON_EFFECT)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetMatchingGroup(c114707556.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if ct==0 or g:GetCount()==0 or ct>ft then return end
    if ct>g:GetClassCount(Card.GetCode) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=g:Select(tp,1,1,nil)
    if ct==2 then
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
end

function c114707556.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c114707556.thfilter1(c)
    return c:IsSetCard(0xc6) and c:IsAbleToGrave()
end
function c114707556.thfilter2(c)
    return c:IsSetCard(0xc6) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c114707556.thfilter3(c,e,tp)
    return c:IsSetCard(0xc6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114707556.thfilter4(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c114707556.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    local hg1=Duel.GetMatchingGroup(c114707556.thfilter1,tp,LOCATION_DECK,0,nil)
    if ct>=1 and hg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local shg1=hg1:Select(tp,1,1,nil)
        Duel.SendtoGrave(shg1,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
    end
    local hg2=Duel.GetMatchingGroup(c114707556.thfilter2,tp,LOCATION_DECK,0,nil)
    if ct>=2 and hg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local shg2=hg2:Select(tp,1,1,nil)
        local tcc=shg2:GetFirst()
        Duel.MoveToField(tcc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        Duel.ShuffleDeck(tp)
    end
    local hg3=Duel.GetMatchingGroup(c114707556.thfilter3,tp,LOCATION_DECK,0,nil,e,tp)
    if ct>=3 and hg3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,4)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local shg3=hg3:Select(tp,1,1,nil)
        Duel.SpecialSummon(shg3,0,tp,tp,false,false,POS_FACEUP)
        Duel.ShuffleDeck(tp)
    end
    local hg4=Duel.GetMatchingGroup(c114707556.thfilter4,tp,LOCATION_DECK,0,nil)
    if ct>=4 and hg4:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114707556,5)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local shg4=hg4:Select(tp,1,1,nil)
        Duel.SendtoHand(shg4,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,shg4)
        Duel.ShuffleDeck(tp)
    end
end
