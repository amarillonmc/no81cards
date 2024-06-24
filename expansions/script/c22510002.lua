--机械核
function c22510002.initial_effect(c)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,22510002)
    e3:SetTarget(c22510002.thtg)
    e3:SetOperation(c22510002.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,22511002)
    e4:SetCondition(c22510002.spcon)
    e4:SetTarget(c22510002.lktg)
    e4:SetOperation(c22510002.lkop)
    c:RegisterEffect(e4)
end
function c22510002.filter(c)
    return c:IsSetCard(0xec0) and c:IsAbleToHand()
end
function c22510002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510002.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22510002.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22510002.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c22510002.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c22510002.lkfilter(c,e,tp,mc)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true)   and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and (c:GetLink()==1 or Duel.IsExistingMatchingCard(c22510002.lkfilter2,tp,LOCATION_HAND,0,c:GetLink()-1,nil))
end
function c22510002.lkfilter2(c)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() 
end
function c22510002.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c22510002.lkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22510002.lkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local xg=Duel.SelectMatchingCard(tp,c22510002.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
    if not xg then return end
    local tc=xg:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=Duel.SelectMatchingCard(tp,c22510002.lkfilter2,tp,LOCATION_HAND,0,tc:GetLink()-1,tc:GetLink()-1,nil)
    tg:AddCard(c)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
    tc:CompleteProcedure()
end

local re=Card.IsSetCard
Card.IsSetCard=function(c,name)
    if name==0xec0 and c:IsCode(34442949,22512237) then return true end
    return re(c,name)
end
