--轮回的枷锁 晓美焰
function c60151006.initial_effect(c)
    --ng
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151002,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,60151099)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60151006.discon)
    e1:SetTarget(c60151006.distg)
    e1:SetOperation(c60151006.disop)
    c:RegisterEffect(e1)
    --spsum
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151006,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,60151006)
    e2:SetCost(c60151006.cost)
    e2:SetTarget(c60151006.target)
    e2:SetOperation(c60151006.operation)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151006,2))
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1,6011006)
    e3:SetTarget(c60151006.sptg)
    e3:SetOperation(c60151006.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
end
function c60151006.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():GetOriginalRace()==RACE_SPELLCASTER
end
function c60151006.chlimit(e,ep,tp)
    return tp==ep
end
function c60151006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local opt=Duel.SelectOption(tp,aux.Stringid(60151002,2),aux.Stringid(60151002,3))
    e:SetLabel(opt)
    Duel.SetChainLimit(c60151006.chlimit)
end
function c60151006.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==0 and c:IsAbleToHand() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    else
        --negate
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(60151001,1))
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAINING)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        e1:SetOperation(c60151006.disop2)
        c:RegisterEffect(e1)
    end
end
function c60151006.disop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(c60151006.chlimit)
end
function c60151006.chlimit(e,ep,tp)
    return tp==ep
end
function c60151006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
    Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c60151006.filter2(c,e,tp)
    return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and not c:IsCode(60151006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151006.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60151006.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151006.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60151006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c60151006.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(1-tp,1,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end