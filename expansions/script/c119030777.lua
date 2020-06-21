--影霊衣の術士 シュリット
function c119030777.initial_effect(c)
    --ritual level
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_RITUAL_LEVEL)
    e1:SetValue(c119030777.rlevel)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(119030777,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_RELEASE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,119030777)
    e2:SetCondition(c119030777.thcon)
    e2:SetTarget(c119030777.thtg)
    e2:SetOperation(c119030777.thop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(119030777,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,119030777)
    e3:SetCost(c119030777.exspcost)
    e3:SetTarget(c119030777.exsptg)
    e3:SetOperation(c119030777.exspop)
    c:RegisterEffect(e3)
end
function c119030777.rlevel(e,c)
    local lv=e:GetHandler():GetLevel()
    if c:IsSetCard(0x10b4) then
        local clv=c:GetLevel()
        return lv*65536+clv
    else return lv end
end
function c119030777.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c119030777.filter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c119030777.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119030777.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c119030777.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c119030777.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c119030777.costfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c119030777.exspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c119030777.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c119030777.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c119030777.exspfilter(c,e,tp)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c119030777.exsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c119030777.exspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c119030777.exspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c119030777.exspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        local tc = g:GetFirst()
        if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            Duel.SpecialSummonComplete()
        end
    end
end