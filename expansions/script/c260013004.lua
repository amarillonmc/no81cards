--盾の操手 トラ
function c260013004.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,260013004)
    e1:SetCondition(c260013004.spcon1)
    e1:SetCost(c260013004.spcost1)
    e1:SetTarget(c260013004.sptg1)
    e1:SetOperation(c260013004.spop1)
    c:RegisterEffect(e1)
    
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,260014004)
    e2:SetTarget(c260013004.thtg)
    e2:SetOperation(c260013004.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end


--【特殊召喚】
function c260013004.cfilter1(c)
    return c:GetSequence()>=5
end
function c260013004.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c260013004.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c260013004.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) 
end
function c260013004.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013004.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c260013004.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c260013004.spfilter1(c,e,tp,ec)
    return c:IsSetCard(0x943) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_LINK)
        and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c260013004.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013004.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c260013004.spop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c260013004.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c260013004.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c260013004.splimit(e,c)
    return not c:IsRace(RACE_SPELLCASTER)
end


--【サーチ】
function c260013004.thfilter(c)
    return c:IsSetCard(0x943) and c:IsType(TYPE_MONSTER) and not c:IsCode(260013004) and c:IsAbleToHand()
end
function c260013004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013004.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c260013004.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c260013004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end