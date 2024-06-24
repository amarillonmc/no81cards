--聖杯の操手 レックス
function c260013001.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,260013001)
    e1:SetCondition(c260013001.spcon1)
    e1:SetCost(c260013001.spcost1)
    e1:SetTarget(c260013001.sptg1)
    e1:SetOperation(c260013001.spop1)
    c:RegisterEffect(e1)
    
    --tohand
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,260014001)
    e5:SetTarget(c260013001.thtg)
    e5:SetOperation(c260013001.thop)
    c:RegisterEffect(e5)
end


--【特殊召喚】
function c260013001.cfilter1(c)
    return c:GetSequence()>=5
end
function c260013001.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c260013001.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c260013001.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) 
end
function c260013001.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013001.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c260013001.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c260013001.spfilter1(c,e,tp,ec)
    return c:IsSetCard(0x943) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_LINK)
        and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c260013001.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013001.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c260013001.spop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c260013001.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c260013001.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c260013001.splimit(e,c)
    return not c:IsRace(RACE_SPELLCASTER)
end


--【サルベージ】
function c260013001.thfilter(c)
    return c:IsSetCard(0x943) and not c:IsCode(260013001) and c:IsAbleToHand() and c:IsFaceup()
end
function c260013001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c260013001.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c260013001.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c260013001.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c260013001.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end