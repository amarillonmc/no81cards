--ちゃくちゃく応戦するＧ
function c49811160.initial_effect(c)
    --change name
    aux.EnableChangeCode(c,46502744,LOCATION_GRAVE)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811160,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c49811160.condition)
    e1:SetTarget(c49811160.sptg)
    e1:SetOperation(c49811160.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c49811160.remcon)
    e2:SetTarget(c49811160.rmtg)
    e2:SetOperation(c49811160.rmop)
    c:RegisterEffect(e2)
    --to grave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811160,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(c49811160.tgcon)
    e3:SetTarget(c49811160.tgtg)
    e3:SetOperation(c49811160.tgop)
    c:RegisterEffect(e3)
end
function c49811160.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and eg:IsExists(c49811160.spfilter,1,nil)
end
function c49811160.spfilter(c)
    return c:IsSummonLocation(LOCATION_GRAVE)
end
function c49811160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811160.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        c:RegisterFlagEffect(49811160,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
    end
    Duel.SpecialSummonComplete()
end
function c49811160.rmfilter(c,tp)
    return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c49811160.remcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(49811160)~=0 and eg:IsExists(c49811160.rmfilter,1,nil,1-tp)
end
function c49811160.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c49811160.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,1,1,nil)
    if sg:GetCount()>0 then
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end
function c49811160.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c49811160.tgfilter(c)
    return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c49811160.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811160.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c49811160.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c49811160.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end