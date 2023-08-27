--ぎりぎり対峙するＧ
function c49811161.initial_effect(c)
    c:EnableCounterPermit(0x4981)
    --change name
    aux.EnableChangeCode(c,15721123,LOCATION_GRAVE)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811161,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c49811161.condition)
    e1:SetTarget(c49811161.sptg)
    e1:SetOperation(c49811161.spop)
    c:RegisterEffect(e1)
    --remove counter
    local e2=Effect.CreateEffect(c) 
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c49811161.rctcon)
    e2:SetOperation(c49811161.rctop)
    c:RegisterEffect(e2)
    --can not spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811161,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCondition(c49811161.lvcon)
    e3:SetOperation(c49811161.lvop)
    c:RegisterEffect(e3)
end
function c49811161.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)==0 and rp==1-tp
end
function c49811161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811161.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cn=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND,nil)
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
        c:AddCounter(0x4981,cn)
        c:CompleteProcedure()
    end
end
function c49811161.cfilter(c,tp)
    return c:IsSummonPlayer(1-tp)
end
function c49811161.rctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811161.cfilter,1,nil,tp)
end
function c49811161.rctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        if c:IsCanRemoveCounter(tp,0x4981,1,REASON_EFFECT) then
            c:RemoveCounter(tp,0x4981,1,REASON_EFFECT)
        else
            Duel.Destroy(c,REASON_EFFECT)
        end
    end
end
function c49811161.lvcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c49811161.lvop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end