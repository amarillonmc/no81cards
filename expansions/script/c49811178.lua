--A・O・J バスアーキテクチャ
function c49811178.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811178,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811178)
    e1:SetCondition(c49811178.spcon)
    e1:SetTarget(c49811178.sptg)
    e1:SetOperation(c49811178.spop)
    c:RegisterEffect(e1)
    --extra attak
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e2:SetCondition(c49811178.exacon)
    e2:SetOperation(c49811178.exaop)
    c:RegisterEffect(e2)
end
function c49811178.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c49811178.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c49811178.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        if Duel.SelectYesNo(tp,aux.Stringid(49811178,1)) then
            Duel.BreakEffect()
            local ct=0
            if Duel.SelectYesNo(tp,aux.Stringid(49811178,2)) then
                local ft1=c:GetLevel()-1
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then
                    ft1=1
                end
                ft1=math.min(ft1,(Duel.GetLocationCount(1-tp,LOCATION_MZONE)))
                if ft1<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,39811178,1,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) then
                    return
                end
                repeat
                    local token=Duel.CreateToken(tp,39811178)
                    Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_DEFENSE)
                    ft1=ft1-1
                    ct=ct+1
                until ft1<=0 or not Duel.SelectYesNo(tp,aux.Stringid(49811178,2))
                Duel.SpecialSummonComplete()
            end
            if Duel.SelectYesNo(tp,aux.Stringid(49811178,3)) then
                local ft2=c:GetLevel()-ct-1
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then
                    ft2=1-ct
                end
                ft2=math.min(ft2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
                if ft2<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,39811178,1,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) then
                    return 
                end
                repeat
                    local token=Duel.CreateToken(tp,39811178)
                    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_DEFENSE)
                    ft2=ft2-1
                    ct=ct+1
                until ft2<=0 or not Duel.SelectYesNo(tp,aux.Stringid(49811178,3))
                Duel.SpecialSummonComplete()
            end
            if ct>0 then
                Duel.BreakEffect()
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_LEVEL)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(-ct)
                c:RegisterEffect(e1)
            end    
        end
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c49811178.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c49811178.splimit(e,c)
    return not c:IsSetCard(1)
end
function c49811178.exacon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsRace(RACE_MACHINE)
end
function c49811178.exaop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811178,4))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_ALL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
end