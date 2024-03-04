--ユニグリファント
function c49811305.initial_effect(c)
    --splimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EFFECT_SPSUMMON_CONDITION)
    e4:SetValue(c49811305.splimit)
    c:RegisterEffect(e4)
    --same effect banish this card spsummon another card check
    local e0=aux.AddThisCardInGraveAlreadyCheck(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811305,2))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c49811305.spcost)
    e1:SetTarget(c49811305.sptg)
    e1:SetOperation(c49811305.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811305,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,49811305)
    e2:SetCost(c49811305.rmcost)
    e2:SetTarget(c49811305.rmtg)
    e2:SetOperation(c49811305.rmop)
    c:RegisterEffect(e2)
    --remove special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811305,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCountLimit(1,49811306)
    e3:SetLabelObject(e0)
    e3:SetCondition(c49811305.rspcon)
    e3:SetTarget(c49811305.rsptg)
    e3:SetOperation(c49811305.rspop)
    c:RegisterEffect(e3)
end
function c49811305.splimit(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c49811305.chfilter(c)
    return c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c49811305.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(c49811305.chfilter,tp,LOCATION_HAND,0,1,nil) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c49811305.chfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c49811305.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c49811305.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then 
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
    end
end
function c49811305.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    return true
end
function c49811305.cfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WINDBEAST+RACE_BEAST) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c49811305.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c49811305.tgfilter(c,rc)
    return c:IsAbleToRemove() and c:IsRace(rc:GetRace())
end
function c49811305.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(c49811305.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c49811305.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    e:SetLabelObject(g:GetFirst())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811305.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rc=e:GetLabelObject()
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811305.tgfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,rc)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c49811305.rcfilter(c,tp,se)
    return c:IsSummonLocation(LOCATION_REMOVED) and c:GetOwner()==tp
        and (se==nil or c:GetReasonEffect()~=se)
end
function c49811305.rspcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
    return eg:IsExists(c49811305.rcfilter,1,nil,tp,se)
end
function c49811305.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811305.rspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(RACE_BEAST)
        c:RegisterEffect(e1,true)
    end
    Duel.SpecialSummonComplete()
end