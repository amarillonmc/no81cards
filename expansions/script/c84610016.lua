--ＥＭペンデュラムの魔術師　
function c84610016.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --extra pendulum
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(84610016,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,84610016)
    e1:SetCost(c84610016.expcost)
    e1:SetTarget(c84610016.exptg)
    e1:SetOperation(c84610016.expop)
    c:RegisterEffect(e1)
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84610016,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,84611016)
    e2:SetTarget(c84610016.settg)
    e2:SetOperation(c84610016.setop)
    c:RegisterEffect(e2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)    
    e1:SetCountLimit(1,84612016)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c84610016.spcon)
    e1:SetCost(c84610016.spcost)
    e1:SetTarget(c84610016.sptg)
    e1:SetOperation(c84610016.spop)
    c:RegisterEffect(e1)
    --special summon+tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,84613016)
    e2:SetCondition(c84610016.tspcon)
    e2:SetTarget(c84610016.tsptg)
    e2:SetOperation(c84610016.tspop)
    c:RegisterEffect(e2)
    --pendulum
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c84610016.pencon)
    e3:SetTarget(c84610016.pentg)
    e3:SetOperation(c84610016.penop)
    c:RegisterEffect(e3)
end
c84610016.pendulum_level=4
function c84610016.filter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c84610016.expcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610016.filter,tp,LOCATION_EXTRA,0,10,nil) end
    local g=Duel.GetMatchingGroup(c84610016.filter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()<10 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,10,10,nil)
    Duel.SendtoDeck(sg,nil,0,REASON_COST)
end
function c84610016.exptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c84610016.expop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(84610016,2))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(aux.TRUE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c84610016.setfilter1(c,tp)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
        and Duel.IsExistingMatchingCard(c84610016.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c84610016.setfilter2(c,code)
    return not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c84610016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return Duel.IsExistingMatchingCard(c84610016.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c84610016.setop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if g:GetCount()<2 then return end
    if Duel.Destroy(g,REASON_EFFECT)==2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g1=Duel.SelectMatchingCard(tp,c84610016.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
        local tc1=g1:GetFirst()
        if not tc1 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g2=Duel.SelectMatchingCard(tp,c84610016.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode())
        local tc2=g2:GetFirst()
        if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
            if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
                tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
            end
            tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
        end
    end
end
function c84610016.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c84610016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c84610016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_EXTRA)
end
function c84610016.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
    if not c:IsRelateToEffect(e) then return end
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
        c:CompleteProcedure()
    end
end
function c84610016.tspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c84610016.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c84610016.thfilter,tp,LOCATION_EXTRA,0,1,c)
end
function c84610016.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c84610016.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610016.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84610016.tspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,c84610016.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local tg=Duel.SelectMatchingCard(tp,c84610016.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)    
            if tg:GetCount()>0 then
                Duel.SendtoHand(tg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tg)
            end
        end
    end
end
function c84610016.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE)
end
function c84610016.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c84610016.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
