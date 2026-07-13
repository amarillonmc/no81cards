--源于黑影 耳鸣
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.maintg)
    e1:SetOperation(s.mainop)
    c:RegisterEffect(e1)

    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_CUSTOM+65820000)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.spcon)
    e3:SetCost(aux.bfgcost)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
    for i=0,10 do
        Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
    end
    local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
    Duel.ResetFlagEffect(tp,65820099)
    for i=1,count do
        Duel.RegisterFlagEffect(tp,65820099,0,0,1)
    end
    local te=Effect.CreateEffect(e:GetHandler())
    te:SetDescription(aux.Stringid(65820000,count))
    te:SetType(EFFECT_TYPE_FIELD)
    te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
    te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    te:SetTargetRange(1,0)
    Duel.RegisterEffect(te,tp)
end

function s.filter2(c,e)
    return c:IsFaceup() and not c:IsImmuneToEffect(e)
end

function s.filter1(c)
    return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,c:GetControler(),0,LOCATION_ONFIELD,1,c)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local has_use=Duel.GetFlagEffect(tp,65820099)>0
    local is_flipped=c:GetFlagEffect(65820010)>0

    if (not has_use and not is_flipped) or (has_use and is_flipped) then
        return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
    end
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local has_use=Duel.GetFlagEffect(tp,65820099)>0
    local is_flipped=c:GetFlagEffect(65820010)>0

    if (not has_use and not is_flipped) or (has_use and is_flipped) then
        if chk==0 then
            return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
        end
        if has_use then s.consume_use_counter(e,tp) end
        e:SetLabel(1)
        e:SetCategory(CATEGORY_ATKCHANGE)
    else
        if chk==0 then
            return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
        end
        if has_use then s.consume_use_counter(e,tp) end
        e:SetLabel(2)
        e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
        local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
        local g2=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
    end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==1 then
        local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
        for tc in aux.Next(sg) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e1:SetValue(0)
            tc:RegisterEffect(e1)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c):GetFirst()
        if tc then
            Duel.HintSelection(Group.FromCards(tc))
            local p=tc:GetControler()
            if Duel.Destroy(tc,REASON_EFFECT)~=0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
                local sc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,p,0,LOCATION_ONFIELD,1,1,c):GetFirst()
                if sc and sc:IsFaceup() and sc:IsCanBeDisabledByEffect(e,false) then
                    Duel.NegateRelatedChain(sc,RESET_TURN_SET)
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetCode(EFFECT_DISABLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    sc:RegisterEffect(e1)
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_SINGLE)
                    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e2:SetCode(EFFECT_DISABLE_EFFECT)
                    e2:SetValue(RESET_TURN_SET)
                    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                    sc:RegisterEffect(e2)
                    if sc:IsType(TYPE_TRAPMONSTER) then
                        local e3=Effect.CreateEffect(c)
                        e3:SetType(EFFECT_TYPE_SINGLE)
                        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                        e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
                        sc:RegisterEffect(e3)
                    end
                end
            end
        end
    end
end

function s.cfilter1(c,tp)
    return c:IsSetCard(0x3a32)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1)
    e1:SetCondition(s.negcon)
    e1:SetOperation(s.negop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabel(tp)
    Duel.RegisterEffect(e1,tp)
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActivated()
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetCountLimit(1)
    e2:SetCondition(s.dis2con)
    e2:SetOperation(s.dis2op)
    e2:SetLabelObject(re)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end

function s.dis2con(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsType(TYPE_MONSTER)
end

function s.dis2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.NegateEffect(ev)
end