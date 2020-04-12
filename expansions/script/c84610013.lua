--リチュアの水鏡
function c84610013.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c84610013.matfilter,1,1)
    c:EnableReviveLimit()
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c84610013.imcon)
    e1:SetValue(c84610013.efilter)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,84610013)
    e2:SetCondition(c84610013.condition)
    e2:SetTarget(c84610013.target)
    e2:SetOperation(c84610013.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_MATERIAL_CHECK)
    e3:SetValue(c84610013.valcheck)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(aux.chainreg)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(84610013,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,846100131)
    e5:SetCondition(c84610013.spcon)
    e5:SetTarget(c84610013.sptg)
    e5:SetOperation(c84610013.spop)
    c:RegisterEffect(e5)
    --set
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(84610013,1))
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,846100132)
    e6:SetCondition(c84610013.setcon)
    e6:SetTarget(c84610013.settg)
    e6:SetOperation(c84610013.setop)
    c:RegisterEffect(e6)
end
function c84610013.matfilter(c)
    return c:IsLinkSetCard(0x3a) and not c:IsLinkType(TYPE_LINK)
end
function c84610013.imcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c84610013.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c84610013.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c84610013.filter(c)
    return c:IsSetCard(0x3a) and c:IsAbleToHand()
end
function c84610013.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610013.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610013.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610013.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610013.mfilter(c)
    return bit.band(c:GetType(),0x81)==0x81
end
function c84610013.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(c84610013.mfilter,1,nil) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c84610013.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x3a) and e:GetHandler():GetFlagEffect(1)>0
end
function c84610013.cfilter(c,code)
    return c:IsFaceup() and c:IsCode(code)
end
function c84610013.spfilter(c,e,tp)
    return c:IsSetCard(0x3a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and not Duel.IsExistingMatchingCard(c84610013.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c84610013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610013.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84610013.setcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:IsSetCard(0x3a) and rc:IsControler(tp) and c:GetFlagEffect(1)>0
end
function c84610013.setfilter(c)
    return c:IsSetCard(0x3a) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsSSetable()
end
function c84610013.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610013.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c84610013.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c84610013.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
    end
end
