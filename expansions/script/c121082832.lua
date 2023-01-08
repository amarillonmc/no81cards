function c121082832.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_PREDRAW)
    e0:SetCountLimit(1,121082832+EFFECT_COUNT_CODE_DUEL)
    e0:SetRange(LOCATION_HAND+LOCATION_DECK)
    e0:SetOperation(c121082832.op)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c121082832.target)
    c:RegisterEffect(e1)
end
function c121082832.effilter(c)
    return c:IsFaceup() and c:GetOriginalCode()==121082832
end
function c121082832.effcon(e)
    return Duel.IsExistingMatchingCard(c121082832.effilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c121082832.repfilter(c,tc)
    return c==tc and c:IsFacedown()
end
function c121082832.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c121082832.repfilter,1,nil,e:GetOwner()) end
    return true
end
function c121082832.desrepval(e,c)
    return c121082832.repfilter(c,e:GetOwner())
end
function c121082832.con(e)
    return e:GetOwner():GetFlagEffect(121082832)>0 and e:GetOwner():IsFacedown()
end
function c121082832.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()~=e:GetOwner()
end
function c121082832.setlimit(e,c,tp)
    return c:IsType(TYPE_FIELD) and c~=e:GetOwner()
end
function c121082832.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
    Duel.ConfirmCards(1-tp,c)
    c:RegisterFlagEffect(121082832,RESET_EVENT+RESETS_STANDARD,0,1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,1)
    e3:SetCondition(c121082832.effcon)
    e3:SetCode(EFFECT_CHANGE_CODE)
    e3:SetValue(121082832)
    Duel.RegisterEffect(e3,tp)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e7:SetRange(LOCATION_FZONE)
    e7:SetCode(EFFECT_SEND_REPLACE)
    e7:SetTarget(c121082832.desreptg)
    e7:SetValue(c121082832.desrepval)
    Duel.RegisterEffect(e7,tp)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c121082832.con)
    e1:SetValue(c121082832.actlimit)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetCondition(c121082832.con)
    e2:SetTarget(c121082832.setlimit)
    Duel.RegisterEffect(e2,tp)
end
function c121082832.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_FZONE)
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
        e1:SetRange(LOCATION_FZONE)
        e1:SetCountLimit(1+EFFECT_COUNT_CODE_DUEL)
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
