--魂之座
local m=89390006
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
    aux.AddContactFusionProcedure(c,cm.mfilter,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(cm.descon)
    e7:SetTarget(cm.destg)
    e7:SetOperation(cm.desop)
    c:RegisterEffect(e7)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_REMOVE)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCondition(cm.thcon)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    e7:SetOperation(cm.atklimit)
    c:RegisterEffect(e7)
    if not cm.global_check then
        cm.global_check=true
        cm[0]={}
        cm[1]={}
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
function cm.ffilter(c,fc,sub,mg,sg)
    return c:IsRace(RACE_PSYCHO) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cm.mfilter(c)
    local tp=c:GetControler()
    local rc=c:GetFusionCode()
    return cm[tp][rc] and cm[tp][rc]>=2 and c:IsAbleToRemoveAsCost()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetMaterial():IsExists(Card.IsFusionCode,1,nil,89390004)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local ac=tc:GetCode()
        c:SetHint(CHINT_CARD,ac)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_ADJUST)
        e2:SetRange(LOCATION_MZONE)
        e2:SetLabel(ac)
        e2:SetOperation(cm.adjustop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
        c:RegisterEffect(e2)
    end
end
function cm.adjfilter(c,code)
    return c:IsFaceup() and c:IsCode(code)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local g=Duel.GetMatchingGroup(cm.adjfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        Duel.Readjust()
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(m)>0
end
function cm.spfilter1(c,e,tp,tid)
    return c:GetTurnID()==tid and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tid=Duel.GetTurnCount()
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,tid) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tid=Duel.GetTurnCount()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,tid) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp,tid)
        if tg:GetCount()<=0 then return end
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.atklimit(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_PSYCHO) then
        local rc=re:GetHandler():GetCode()
        if cm[rp][rc] then cm[rp][rc]=cm[rp][rc]+1 else cm[rp][rc]=1 end
    end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler():GetCode()
    if cm[rp][rc] then cm[rp][rc]=cm[rp][rc]-1 else cm[rp][rc]=nil end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
    cm[0]={}
    cm[1]={}
end
