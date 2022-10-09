local m=4865007
local cm=_G["c"..m] 
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(cm.reptg)
    e2:SetValue(cm.repval)
    e2:SetOperation(cm.repop)
    c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp,check)
    return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (check or c:IsCode(4865010))
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x332b)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local check=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        local check=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
            Duel.Damage(tp,1000,REASON_EFFECT)
        end
        Duel.SpecialSummonComplete()
    end
    if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
    return not c:IsSetCard(0x332b) and c:IsLocation(LOCATION_EXTRA)
end
function cm.repfilter(c,tp)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_LINK)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
    return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

