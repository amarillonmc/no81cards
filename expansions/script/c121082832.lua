function c121082832.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,121082832+EFFECT_COUNT_CODE_DUEL)
    e1:SetTarget(c121082832.target)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,1)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetValue(121082832)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetRange(LOCATION_DECK)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_DECK)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c121082832.actarget)
    e4:SetOperation(c121082832.costop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SPSUMMON_PROC_G)
    e5:SetRange(LOCATION_DECK)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e5)
end
function c121082832.actarget(e,te,tp)
    return te:GetHandler()==e:GetHandler()
end
function c121082832.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c121082832.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c121082832.descon)
    e1:SetOperation(c121082832.desop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
    c:SetTurnCounter(0)
    c:RegisterEffect(e1)
end
function c121082832.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c121082832.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==3 then
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetRange(LOCATION_SZONE)
        e1:SetCountLimit(1)
        e1:SetTarget(c121082832.target2)
        e1:SetOperation(c121082832.operation2)
        c:RegisterEffect(e1)
    end
end
function c121082832.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c121082832.operation2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
    Duel.SetLP(tp,4000)
    if Duel.GetLP(tp)<Duel.GetLP(1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(121082832,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.ShuffleDeck(tp)
            Duel.MoveSequence(tc,0)
            Duel.ConfirmDecktop(tp,1)
        end
    end
end