function c10080420.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c10080420.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c10080420.spcon)
    e2:SetOperation(c10080420.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(2)
    e3:SetCondition(c10080420.thcon)
    e3:SetOperation(c10080420.thop)
    c:RegisterEffect(e3)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetCondition(c10080420.leavecon)
    e6:SetOperation(c10080420.leaveop)
    c:RegisterEffect(e6)
end
function c10080420.Isshinka(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0x10e) or c:IsCode(5338223,8632967,14154221,24362891,25573054,34026662,62991886,64815084,74100225,77840540,88760522,93504463,10080420))
end
function c10080420.spcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==tp and c10080420.Isshinka(re:GetHandler())
end
function c10080420.spfilter(c,e,tp)
    return c:IsSetCard(0x4e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10080420.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(10080420)>1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    local g=Duel.GetMatchingGroup(c10080420.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()<1 then
        Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
        return
    end
    Duel.Hint(HINT_CARD,0,10080420)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:Select(tp,1,1,nil)
    if not sg then return end
    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    c:RegisterFlagEffect(10080420,RESET_PHASE+PHASE_END,0,1)
end
function c10080420.xfilter(c,tp)
    return c:IsSetCard(0x504e) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c10080420.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10080420.xfilter,1,nil,tp)
end
function c10080420.thfilter(c)
    return c10080420.Isshinka(c) and c:IsAbleToHand()
end
function c10080420.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c10080420.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()<1 then
        Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
        return
    end
    Duel.Hint(HINT_CARD,0,10080420)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    if not sg then return end
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
end
function c10080420.leavecon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c10080420.leavefilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10080420.leaveop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
    local g=Duel.GetMatchingGroup(c10080420.leavefilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
end