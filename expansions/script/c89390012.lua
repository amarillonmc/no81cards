--永恒幽灵
local m=89390012
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,Card.IsTuner,cm.ffilter,true)
    aux.AddContactFusionProcedure(c,cm.mfilter,LOCATION_HAND+LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetOperation(cm.regop)
    c:RegisterEffect(e3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_F)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e2:SetCondition(cm.immcon)
    e2:SetCost(cm.cost)
    e2:SetOperation(cm.immop)
    c:RegisterEffect(e2)
    if not cm.global_check then
        cm.global_check=true
        cm[0]={}
        cm[1]={}
        cm[2]={}
        cm[3]={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_CHAIN_NEGATED)
        ge2:SetOperation(cm.regop2)
        Duel.RegisterEffect(ge2,0)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge4:SetOperation(cm.clearop)
        Duel.RegisterEffect(ge4,0)
    end
end
function cm.ffilter(c)
    return not c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsFusionType(TYPE_FUSION)
end
function cm.mfilter(c)
    local tp=c:GetControler()
    local rc=c:GetFusionCode()
    return not cm[tp][rc] and cm[tp+2][rc] and c:IsAbleToRemoveAsCost()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:GetMaterial() then return end
    c:GetMaterial():ForEach(cm.regmf,c)
end
function cm.regmf(c,tc)
    if c:IsRace(RACE_PSYCHO+RACE_MACHINE) then 
        tc:CopyEffect(c:GetOriginalCode(),RESET_EVENT+0x1fe0000)
    end
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.costfilter(c,rc)
    return c:IsType(rc:GetType()) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,re:GetHandler()) end
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,re:GetHandler())
        Duel.Remove(g,POS_FACEUP,REASON_COST)
        Duel.SetChainLimit(aux.FALSE)
    end
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(cm.efilter)
        e1:SetLabel(re:GetHandler():GetCode())
        c:RegisterEffect(e1)
    end
end
function cm.efilter(e,te)
    return te:GetHandler():IsCode(e:GetLabel())
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_MONSTER) then
        local rc=re:GetHandler():GetCode()
        if cm[rp][rc] then cm[rp][rc]=cm[rp][rc]+1 else cm[rp][rc]=1 end
        if cm[rp+2][rc] then cm[rp+2][rc]=cm[rp+2][rc]+1 else cm[rp+2][rc]=1 end
    end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler():GetCode()
    if cm[rp][rc] then cm[rp][rc]=cm[rp][rc]-1 else cm[rp][rc]=nil end
    if cm[rp+2][rc] then cm[rp+2][rc]=cm[rp+2][rc]-1 else cm[rp+2][rc]=nil end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
    cm[0]={}
    cm[1]={}
end
