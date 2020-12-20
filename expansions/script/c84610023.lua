--究極壊獣アンノウン
function c84610023.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    --auto Pset
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1,84610023)
    e1:SetCondition(c84610023.setcon)
    e1:SetTarget(c84610023.settg)
    e1:SetOperation(c84610023.setop)
    c:RegisterEffect(e1)
    --unaffectable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c84610023.efilter)
    c:RegisterEffect(e3)
    --token
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_PZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c84610023.setcon)
    e4:SetTarget(c84610023.sptg)
    e4:SetOperation(c84610023.spop)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(84610023,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c84610023.hsptg)
    e5:SetOperation(c84610023.hspop)
    c:RegisterEffect(e5)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --control
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(c84610023.ctcon)
    e2:SetTarget(c84610023.cttg)
    e2:SetOperation(c84610023.ctop)
    c:RegisterEffect(e2)
    --unaffectable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetTarget(c84610023.indestg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c84610023.efilter)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e5)
    local e6=e3:Clone()
    e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e6)
end
function c84610023.setcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c84610023.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,2,nil) end
end
function c84610023.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function c84610023.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c84610023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c84610023.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
    local ct=ft
    if ct>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
    if ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,84610024,0,0,0,0,11,RACE_ALL,ATTRIBUTE_ALL,POS_FACEUP_DEFENSE,1-tp) then
        for i=1,ct do
            local token=Duel.CreateToken(tp,84610024)
            Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
        end
        Duel.SpecialSummonComplete()
    end
end
function c84610023.hspfilter(c)
    return c:IsSetCard(0xd3) and c:IsReleasableByEffect() and c:IsFaceup()
end
function c84610023.relfilter(c)
    return c:IsReleasableByEffect()
end
function c84610023.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c84610023.relfilter,tp,0,LOCATION_MZONE,nil)
    if chk==0 then return g:GetCount()>1 and g:IsExists(c84610023.hspfilter,1,nil,tp) 
        and Duel.GetMZoneCount(1-tp,g)>0 and Duel.IsPlayerCanRelease(tp)
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610023.spfilter(c,e,tp)
    return c:IsSetCard(0xd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610023.spcheck(g)
    return g:GetClassCount(Card.GetCode)==#g
end
function c84610023.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetMatchingGroup(c84610023.relfilter,tp,0,LOCATION_MZONE,nil)
    if rg:GetCount()>1 and rg:IsExists(c84610023.hspfilter,1,nil,tp) and Duel.Release(rg,REASON_EFFECT) then
        local og=Duel.GetOperatedGroup()
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,true,true,POS_FACEUP)>0 then
            if og:GetCount()>0 then
                Duel.BreakEffect()
                local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
                local ct=og:GetCount()
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
                if ct>ft then ct=ft end
                if ft>0 then
                    local g=Duel.GetMatchingGroup(c84610023.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
                    if g:GetCount()>0 then
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                        local sg=g:SelectSubGroup(tp,c84610023.spcheck,false,1,ct)
                        local tc=sg:GetFirst()
                        while tc do
                            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
                            tc=sg:GetNext()
                        end
                    end
                end
                Duel.SpecialSummonComplete()                
                local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
                local ct=og:GetCount()
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
                if ct>ft then ct=ft end
                if ft>0 then
                    local g=Duel.GetMatchingGroup(c84610023.spfilter,1-tp,LOCATION_DECK,0,nil,e,1-tp)
                    if g:GetCount()>0 then
                        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
                        local sg=g:SelectSubGroup(1-tp,c84610023.spcheck,false,1,ct)
                        local tc=sg:GetFirst()
                        while tc do
                            Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
                            tc=sg:GetNext()
                        end
                    end
                end
                Duel.SpecialSummonComplete()
            end
        end
    end
end
function c84610023.ctcon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and at:IsCode(84610023)
end
function c84610023.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c84610023.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if not (c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0) or not (tc:IsAbleToChangeControler() and Duel.GetMZoneCount(1-tp,tc,1-tp,LOCATION_REASON_CONTROL)>0)
    then return end
    if c:IsRelateToEffect(e) then
        Duel.SwapControl(c,tc,0,0)
    end
end
function c84610023.indestg(e,c)
    return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER)
end
function c84610023.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
