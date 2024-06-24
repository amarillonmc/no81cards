--雷の操手 ジーク
function c260013003.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,260013003)
    e1:SetCondition(c260013003.spcon1)
    e1:SetCost(c260013003.spcost1)
    e1:SetTarget(c260013003.sptg1)
    e1:SetOperation(c260013003.spop1)
    c:RegisterEffect(e1)
    
    --set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,260014003)
    e2:SetCondition(c260013003.setcon)
    e2:SetTarget(c260013003.settg)
    e2:SetOperation(c260013003.setop)
    c:RegisterEffect(e2)
end


--【特殊召喚】
function c260013003.cfilter1(c)
    return c:GetSequence()>=5
end
function c260013003.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c260013003.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c260013003.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) 
end
function c260013003.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013003.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c260013003.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c260013003.spfilter1(c,e,tp,ec)
    return c:IsSetCard(0x943) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_LINK)
        and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c260013003.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013003.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c260013003.spop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c260013003.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c260013003.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c260013003.splimit(e,c)
    return not c:IsRace(RACE_SPELLCASTER)
end


--【魔法・罠セット】
function c260013003.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c260013003.stfilter(c)
    return c:IsSetCard(0x943) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
        and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c260013003.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c260013003.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c260013003.setop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c260013003.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
    if #g>0 then
        Duel.SSet(tp,g)
    end
end