--影霊衣の戦士 エグザ
function c115318002.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(115318002,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_RELEASE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,115318002)
    e1:SetCondition(c115318002.thcon)
    e1:SetTarget(c115318002.thtg)
    e1:SetOperation(c115318002.thop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(115318002,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,115318002)
    e2:SetTarget(c115318002.sptg)
    e2:SetOperation(c115318002.spop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(115318002,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,115318002)
    e3:SetCost(c115318002.exspcost)
    e3:SetTarget(c115318002.exsptg)
    e3:SetOperation(c115318002.exspop)
    c:RegisterEffect(e3)
end
function c115318002.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c115318002.thfilter(c)
    return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c115318002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115318002.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115318002.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115318002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c115318002.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c115318002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c115318002.spfilter(chkc,e,tp) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c115318002.spfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c115318002.spfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c115318002.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end

function c115318002.costfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c115318002.exspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c115318002.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c115318002.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c115318002.exspfilter(c,e,tp)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c115318002.exsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c115318002.exspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c115318002.exspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c115318002.exspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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