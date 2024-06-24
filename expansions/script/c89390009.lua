--凶星·新监察官
local m=89390009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
    aux.AddContactFusionProcedure(c,cm.mfilter,LOCATION_REMOVED,0,Duel.SendtoDeck,nil,2,REASON_COST+REASON_MATERIAL)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    local e0=Effect.CreateEffect(c) 
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
    e0:SetCode(EVENT_SPSUMMON_SUCCESS) 
    e0:SetOperation(cm.splimitop) 
    c:RegisterEffect(e0)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetOperation(cm.imop)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(cm.efilter)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.ctcon)
    e3:SetOperation(cm.ctop)
    c:RegisterEffect(e3)
    if not cm.global_check then
        cm.global_check=true
        cm[10000]={}
        cm[10001]={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_CHAIN_NEGATED)
        ge2:SetOperation(cm.regop2)
        Duel.RegisterEffect(ge2,0)
        local ge3=Effect.CreateEffect(c)
        ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge3:SetCode(EVENT_CHAINING)
        ge3:SetOperation(cm.check)
        Duel.RegisterEffect(ge3,0)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_CHAIN_SOLVED)
        ge4:SetCondition(cm.clearcon)
        ge4:SetOperation(cm.clear)
        Duel.RegisterEffect(ge4,0)
        local ge5=ge4:Clone()
        ge5:SetCode(EVENT_CHAIN_NEGATED)
        Duel.RegisterEffect(ge5,0)
        local ge6=ge3:Clone()
        ge6:SetCode(EVENT_CHAIN_NEGATED)
        ge6:SetCondition(cm.rscon)
        ge6:SetOperation(cm.reset)
        --when the trigger=true, if the activation of the last effect "c4" was negated, this card effect's applying or not will depend on "c3". when the trigger=false, it will depend on "c4".
        local trigger=true
        if trigger then Duel.RegisterEffect(ge6,0) end
    end
end
cm.cd=3
function cm.ffilter(c,fc,sub,mg,sg)
    return c:IsRace(RACE_PSYCHO) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.mfilter(c)
    local tp=c:GetControler()
    local rc=c:GetFusionCode()
    return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) and cm[tp+10000][rc] and cm[tp+10000][rc]>0 and c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function cm.splimitop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
    Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,te)
    local tp=e:GetHandlerPlayer()
    if not te:IsActivated() or tp==te:GetOwnerPlayer() then return false end
    local res=true
    local i=1
    while type(cm[i])=="table" do
        local re,rp=table.unpack(cm[i])
        if rp==tp then res=true end
        if rp==1-tp then res=false end
        i=i+1
    end
    return res
end
cm[0]=0
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
    local res=true
    local i=1
    while type(cm[i])=="table" do
        local re,rp=table.unpack(cm[i])
        if rp==tp then res=true end
        if rp==1-tp then res=false end
        i=i+1
    end
    if not res then return end
    local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    if ep==tp or id==cm[0] then return end
    cm[0]=id
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
        Duel.Hint(HINT_CARD,0,m)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:RandomSelect(tp,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.HintSelection(sg1)
        Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    cm.cd=cm.cd-1
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local p=rp+10000
    if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_PSYCHO) then
        local rc=re:GetHandler():GetCode()
        if cm[p][rc] then cm[p][rc]=cm[p][rc]+1 else cm[p][rc]=1 end
    end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    local p=rp+10000
    local rc=re:GetHandler():GetCode()
    if cm[p][rc] then cm[p][rc]=cm[p][rc]-1 else cm[p][rc]=nil end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
    cm[ev]={re,rp}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
    cm[ev]={re,2}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
    local i=1
    while cm[i] do
        cm[i]=nil
        i=i+1
    end
end
