--机械射手
function c22510004.initial_effect(c)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,22510004)
    e3:SetCondition(c22510004.spcon)
    e3:SetTarget(c22510004.sptg)
    e3:SetOperation(c22510004.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,22511004)
    e4:SetCost(c22510004.discost)
    e4:SetTarget(c22510004.rmtg)
    e4:SetOperation(c22510004.rmop)
    c:RegisterEffect(e4)
end
function c22510004.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c22510004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,Duel.GetLinkedZone(tp))>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and e:GetHandler():GetFlagEffect(22510004)==0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(22510004,RESET_CHAIN,0,1)
end
function c22510004.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=Duel.GetLinkedZone(tp)
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c22510004.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        g:RemoveCard(e:GetHandler())
        return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
    end
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c22510004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c22510004.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    if not g then return end
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_SKIP_DP)
    e1:SetTargetRange(1,0)
    if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
    end
    Duel.RegisterEffect(e1,tp)
end
