--告解的壁障 佐仓杏子
function c60152002.initial_effect(c)
    --sp
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_SPSUMMON_PROC)
    e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c60152002.spcon2)
    e12:SetOperation(c60152002.spop2)
    c:RegisterEffect(e12)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152002,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,60152002)
    e1:SetCondition(c60152002.con)
    e1:SetTarget(c60152002.target)
    e1:SetOperation(c60152002.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152002,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
    e3:SetCountLimit(1,6012002)
    e3:SetCondition(c60152002.con)
    e3:SetOperation(c60152002.activate2)
    c:RegisterEffect(e3)
end
function c60152002.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c60152002.spfilter2(c)
    return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
        or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsReleasable()
end
function c60152002.spcon2(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then 
        return Duel.IsExistingMatchingCard(c60152002.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
            and Duel.IsExistingMatchingCard(c60152002.spfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
    else
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
            and Duel.IsExistingMatchingCard(c60152002.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
    end
end
function c60152002.spop2(e,tp,eg,ep,ev,re,r,rp,c)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=Duel.SelectMatchingCard(tp,c60152002.spfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
        local tc2=g:GetFirst()
        while tc2 do
            if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
            tc2=g:GetNext()
        end
        Duel.Release(g,REASON_COST)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g1=Duel.SelectMatchingCard(tp,c60152002.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
        local tc=g1:GetFirst()
        while tc do
            if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
            tc=g1:GetNext()
        end
        Duel.Release(g1,REASON_COST)
    end
end
function c60152002.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,60152099,0,0x4011,-2,0,4,RACE_PYRO,ATTRIBUTE_FIRE) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60152002.filter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152002.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=2
    if ft>ct then ft=ct end
    if ft<=0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,60152099,0,0x4011,-2,0,4,RACE_PYRO,ATTRIBUTE_FIRE) then return end
    local ctn=true
    while ft>0 and ctn do
        local token=Duel.CreateToken(tp,60152099)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
        local atk=Duel.GetMatchingGroupCount(c60152002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*300
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(atk)
        token:RegisterEffect(e1,true)
        ft=ft-1
        if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(60152002,1)) then ctn=false end
    end
    Duel.SpecialSummonComplete()
end
function c60152002.sumval(e,c)
    return not c:IsSetCard(0x6b25)
end
function c60152002.activate2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(c60152002.filter2))
    e1:SetValue(aux.indoval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60152002.filter2(c)
    return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
        or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE)))
end