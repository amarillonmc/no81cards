--影霊衣の大魔道士
function c127796375.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(127796375,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_RELEASE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,127796375)
    e1:SetCondition(c127796375.thcon)
    e1:SetCost(c127796375.cost)
    e1:SetTarget(c127796375.thtg)
    e1:SetOperation(c127796375.thop)
    c:RegisterEffect(e1)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(127796375,1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,127796375)
    e2:SetCost(c127796375.cost)
    e2:SetTarget(c127796375.tgtg)
    e2:SetOperation(c127796375.tgop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(127796375,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,127796375)
    e3:SetCost(c127796375.spcost)
    e3:SetTarget(c127796375.sptg)
    e3:SetOperation(c127796375.spop)
    c:RegisterEffect(e3)
end
function c127796375.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c127796375.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c127796375.thfilter(c)
    return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c127796375.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c127796375.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c127796375.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c127796375.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c127796375.tgfilter(c)
    return c:IsSetCard(0xb4) and not c:IsCode(127796375) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c127796375.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c127796375.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c127796375.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c127796375.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function c127796375.costfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c127796375.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c127796375.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c127796375.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c127796375.spfilter(c,e,tp)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c127796375.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c127796375.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c127796375.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c127796375.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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