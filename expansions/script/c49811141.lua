--しばしば接触するＧ
function c49811141.initial_effect(c)
    --change name
    aux.EnableChangeCode(c,25137581,LOCATION_GRAVE)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811141,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c49811141.thcon)
    e1:SetTarget(c49811141.thtg)
    e1:SetOperation(c49811141.thop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811141,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,49811141)
    e3:SetCondition(c49811141.spcon)
    e3:SetTarget(c49811141.sptg)
    e3:SetOperation(c49811141.spop)
    c:RegisterEffect(e3)
end
function c49811141.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c49811141.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    Duel.SetTargetPlayer(tp)
end
function c49811141.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    if e:GetHandler():IsRelateToEffect(e) then
        if Duel.SendtoHand(e:GetHandler(),1-p,REASON_EFFECT)~=0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_PUBLIC)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1)   
            c:RegisterFlagEffect(49811141,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,49811141,66) 
        end        
    end
end
function c49811141.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(49811141)>0
end
function c49811141.posfilter(c,e)
    return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end  
function c49811141.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c49811141.posfilter,tp,LOCATION_MZONE,0,nil)
    local sg=#g+1
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,sg,0,0)
end
function c49811141.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
            Duel.BreakEffect()
            local g=Duel.GetMatchingGroup(c49811141.posfilter,tp,LOCATION_MZONE,0,nil)
            Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
        end
    end
end