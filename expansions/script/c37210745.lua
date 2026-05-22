--究极体 隐形突袭兽
local s,id,o=GetID()
function s.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    --e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.discon)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCondition(aux.TRUE)
    c:RegisterEffect(e3)
    --
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,5))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(aux.NOT(s.opspcon))
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetDescription(aux.Stringid(id,6))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e5:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(s.opspcon)
    e5:SetTarget(s.opsptg)
    e5:SetOperation(s.opspop)
    c:RegisterEffect(e5)
end
--

--
function s.release_check(sg)
    return not sg:IsExists(aux.NOT(Card.IsReleasable),1,nil) and sg:GetSum(Card.GetLevel)>10
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    if chk==0 then 
        return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(s.release_check,1,29)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=g:SelectSubGroup(tp,s.release_check,false,1,29)
    if sg and sg:GetCount()>0 then
        Duel.Release(sg,REASON_COST)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetHandler(),1,tp,LOCATION_GRAVE)
    end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
--

--
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    local se=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
    return tp==ep and se and se:GetHandler()==e:GetHandler()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
    local g2=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
    local s1=g1:Filter(Card.IsFaceup,nil):GetCount()>0
    local s2=g1:GetCount()>0 or g2:GetCount()>0
    local el=false
    if s1 or s2 then
        local t={{s1,aux.Stringid(id,2),1},{s2,aux.Stringid(id,3),2},{true,aux.Stringid(id,4),3}}
        local op=aux.SelectFromOptions(tp,table.unpack(t))
        ::skip1::
        if op==1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local sg=g1:Select(tp,1,2,nil)
            local tc=sg:GetFirst()
            while tc do
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetValue(0)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
                e2:SetValue(0)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e2)
                tc=sg:GetNext()
            end
            if el then return end
            el=true
            if s2 then
                t={{s2,aux.Stringid(id,3),1},{true,aux.Stringid(id,4),2}}
                op=aux.SelectFromOptions(tp,table.unpack(t))
                if op==1 then
                    op=2
                else
                    return
                end
            end
        end
        if op==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
            Duel.Destroy(sg,REASON_EFFECT)
            if el then return end
            el=true
            if s1 then
                t={{s1,aux.Stringid(id,2),1},{true,aux.Stringid(id,4),2}}
                op=aux.SelectFromOptions(tp,table.unpack(t))
                if op==1 then
                    goto skip1
                else
                    return
                end
            end
        end
    end
end
--

--
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
    end
end
--

--
function s.opspcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.opsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then 
        return c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
    end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,c,1,tp,LOCATION_HAND)
end
function s.opspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end