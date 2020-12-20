--ガスタの巫女 ウィン
function c84610014.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c84610014.matfilter,1,1)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCost(c84610014.spcost)   
    e1:SetCondition(c84610014.spcon)
    e1:SetTarget(c84610014.sptg)
    e1:SetOperation(c84610014.spop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O) 
    e2:SetCode(EVENT_FREE_CHAIN)    
    e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1) 
    e2:SetCost(c84610014.spcost2)
    e2:SetTarget(c84610014.sptg2)
    e2:SetOperation(c84610014.spop2)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c84610014.spcon2)
    e3:SetTarget(c84610014.sptg3)
    e3:SetOperation(c84610014.spop3)
    c:RegisterEffect(e3)
end
function c84610014.matfilter(c)
    return c:IsLinkSetCard(0x10) and not c:IsLinkType(TYPE_LINK)
end
function c84610014.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c84610014.cosfilter(c)
    return c:IsSetCard(0x10) and c:IsAbleToGraveAsCost()
end
function c84610014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610014.cosfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610014.cosfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c84610014.spfilter(c,e,tp)
    return c:IsSetCard(0x10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610014.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610014.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c84610014.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c84610014.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c84610014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x10)
end
function c84610014.rfilter(c,tp)
    return c:IsSetCard(0x10) and (c:IsControler(tp) or c:IsFaceup())
end
function c84610014.fselect(c,tp,rg,sg)
    sg:AddCard(c)
    if sg:GetCount()<2 then
        res=rg:IsExists(c84610014.fselect,1,sg,tp,rg,sg)
    else
        res=c84610014.fgoal(tp,sg)
    end
    sg:RemoveCard(c)
    return res
end
function c84610014.fgoal(tp,sg)
    if sg:GetCount()>0 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
        Duel.SetSelectedCard(sg)
        return Duel.CheckReleaseGroup(tp,nil,0,nil)
    else return false end
end
function c84610014.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg=Duel.GetReleaseGroup(tp):Filter(c84610014.rfilter,nil,tp)
    local g=Group.CreateGroup()
    if chk==0 then return rg:IsExists(c84610014.fselect,1,nil,tp,rg,g) end
    while g:GetCount()<2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local sg=rg:FilterSelect(tp,c84610014.fselect,1,1,g,tp,rg,g)
        g:Merge(sg)
    end
    Duel.Release(g,REASON_COST)
end
function c84610014.scfilter(c,e,tp)
    return c:IsSetCard(0x10) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c84610014.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
            and Duel.IsExistingMatchingCard(c84610014.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84610014.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610014.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c84610014.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c84610014.spfilter2(c,e,tp)
    return c:IsCode(84610014) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c84610014.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610014.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84610014.spop3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610014.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
    end
end
