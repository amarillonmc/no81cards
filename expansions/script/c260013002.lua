--白虎の操手 ニア
function c260013002.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,260013002)
    e1:SetCondition(c260013002.spcon1)
    e1:SetCost(c260013002.spcost1)
    e1:SetTarget(c260013002.sptg1)
    e1:SetOperation(c260013002.spop1)
    c:RegisterEffect(e1)
    
    --special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,260014002)
    e2:SetTarget(c260013002.sptg2)
    e2:SetOperation(c260013002.spop2)
    c:RegisterEffect(e2)
end


--【特殊召喚】
function c260013002.cfilter1(c)
    return c:GetSequence()>=5
end
function c260013002.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c260013002.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c260013002.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) 
end
function c260013002.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013002.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c260013002.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c260013002.spfilter1(c,e,tp,ec)
    return c:IsSetCard(0x943) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_LINK)
        and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c260013002.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013002.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c260013002.spop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c260013002.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c260013002.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end


function c260013002.splimit(e,c)
    return not c:IsRace(RACE_SPELLCASTER)
end

--【自身を特殊召喚】
function c260013002.releasefilter(c)
    return c:IsReleasableByEffect()
end
function c260013002.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c260013002.releasefilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c260013002.releasefilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    Duel.SelectTarget(tp,c260013002.releasefilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c260013002.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 then
        if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
            e1:SetValue(LOCATION_REMOVED)
            c:RegisterEffect(e1)
        end
    end
    Duel.SpecialSummonComplete()
end