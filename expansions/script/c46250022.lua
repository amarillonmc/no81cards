--骸星装-端杯
function c46250022.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,46250022,LOCATION_MZONE)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(46250022,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCost(c46250022.discost)
    e1:SetTarget(c46250022.rtg)
    e1:SetOperation(c46250022.rop)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(46250022,2))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_PZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c46250022.lvtg)
    e4:SetOperation(c46250022.lvop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,46250022)
    e5:SetTarget(c46250022.tgtg)
    e5:SetOperation(c46250022.tgop)
    c:RegisterEffect(e5)
    local e3=e5:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e6:SetCountLimit(1,146250022)
    e6:SetCondition(c46250022.spcon)
    e6:SetTarget(c46250022.sptg)
    e6:SetOperation(c46250022.spop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetRange(LOCATION_EXTRA)
    e7:SetCountLimit(1,246250022)
    e7:SetCost(c46250022.thcost)
    e7:SetTarget(c46250022.thtg)
    e7:SetOperation(c46250022.thop)
    c:RegisterEffect(e7)
end
function c46250022.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
    Duel.DiscardDeck(tp,1,REASON_COST)
end
function c46250022.filter(c,e,tp,mg)
    if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg1=mg:Clone()
    mg1:RemoveCard(c)
    return mg1:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c46250022.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
        local mg1=Duel.GetRitualMaterial(tp)
        return Duel.IsExistingMatchingCard(c46250022.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp,mg1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c46250022.rop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,tc,tc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c46250022.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp,mg)
    local tc=tg:GetFirst()
    if tc then
        mg:RemoveCard(tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c46250022.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
    local t={}
    local p=1
    for i=2,6 do
        t[p]=i
        p=p+1
    end
    local ac=Duel.AnnounceNumber(tp,table.unpack(t))
    e:SetLabel(ac)
end
function c46250022.lvop(e,tp,eg,ep,ev,re,r,rp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CHANGE_LEVEL)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetValue(e:GetLabel())
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c46250022.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(Card.IsAbleToRemove,e:GetHandler())
    if chk==0 then return g and g:GetCount()>0 and Duel.CheckReleaseGroup(tp,aux.TRUE,1,g) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c46250022.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(Card.IsAbleToRemove,e:GetHandler())
    if not g or g:GetCount()==0 then return end
    local tg=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,g)
    Duel.Release(tg,REASON_EFFECT)
    Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c46250022.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c46250022.spfilter(c,e,tp)
    return c:IsSetCard(0x1fc0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46250022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        local g=Duel.GetMatchingGroup(c46250022.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
        return not Duel.IsPlayerAffectedByEffect(tp,59822133)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c46250022.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c46250022.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
        and g:GetClassCount(Card.GetCode)>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg2=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        for tc in aux.Next(sg1) do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            tc:RegisterEffect(e2)
        end
        Duel.SpecialSummonComplete()
    end
end
function c46250022.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c46250022.thfilter(c)
    return c:IsSetCard(0xfc0) and c:IsAbleToHand()
end
function c46250022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250022.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c46250022.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c46250022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
