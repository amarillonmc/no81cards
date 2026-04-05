local s,id,o=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.atkcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
function s.handfilter(c)
    return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.handcon(e)
    return Duel.IsExistingMatchingCard(s.handfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,2,nil)
end
function s.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3e7a) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.plfilter(c)
    return c:IsSetCard(0x3e7a) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local b1=Duel.GetFlagEffect(tp,id+1)==0
        and Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
    local b2=Duel.GetFlagEffect(tp,id+2)==0
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_GRAVE,0,1,nil)
    if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,
        {b1,aux.Stringid(id,0),1},
        {b2,aux.Stringid(id,1),2})
    e:SetLabel(op)
    if op==1 then
        Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g1=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
        g1:Merge(g2)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
    elseif op==2 then
        Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
        e:SetProperty(0)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==1 then
        local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
        local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
        if #rg>0 then
            Duel.Destroy(rg,REASON_EFFECT)
        end
    elseif op==2 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.plfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
        if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
            e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
            tc:RegisterEffect(e1)
        end
    end
end
function s.cfilter(c,tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.exccon(e) and not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.tg)
    e1:SetValue(1600)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e2,tp)
end
function s.tg(e,c)
    return c:IsRace(RACE_CYBERSE)
end