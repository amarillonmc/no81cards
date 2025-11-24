--神隐
local s,id=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,56433456)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10045474,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_SPSUMMON)
    e2:SetCondition(s.condition)
    e2:SetCost(s.cost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.counterfilter)
end
function s.counterfilter(c)
    return false
end
function s.cfilter(c)
    return c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return  eg:IsExists(s.cfilter,1,nil) and Duel.GetCurrentChain()==0
end
function s.aclimit(e,re,tp)
    local c=re:GetHandler()
    return e:GetLabel()~=c:GetFieldID()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 or Duel.IsEnvironment(56433456) end
    if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and not Duel.IsEnvironment(56433456) then
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetTargetRange(1,0)
    e3:SetLabel(c:GetFieldID())
    e3:SetValue(s.aclimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(s.cfilter,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(s.cfilter,nil)
    Duel.NegateSummon(g)
    Duel.Destroy(g,REASON_EFFECT)
end