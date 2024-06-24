--物語の一幕
function c260013028.initial_effect(c)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c260013028.imtg)
    e1:SetOperation(c260013028.imop)
    c:RegisterEffect(e1)
    
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,260013028)
    e2:SetTarget(c260013028.reptg)
    e2:SetValue(c260013028.repval)
    e2:SetOperation(c260013028.repop)
    c:RegisterEffect(e2)
    
end
    
--【効果モンスター耐性】   
function c260013028.imcfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x943)
end
function c260013028.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013028.imcfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c260013028.imop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c260013028.imcfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetRange(LOCATION_MZONE)     
        e1:SetValue(c260013028.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c260013028.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end

--【身代わり】
function c260013028.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x943) and c:IsLocation(LOCATION_ONFIELD)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c260013028.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and aux.exccon(e) and eg:IsExists(c260013028.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c260013028.repval(e,c)
    return c260013028.repfilter(c,e:GetHandlerPlayer())
end
function c260013028.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
