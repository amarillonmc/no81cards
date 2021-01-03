--真帝机的熔击
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704027
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(cm.distg)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2)
    --atk&def down
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
    e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
    e3:SetCost(cm.adcost)
    e3:SetTarget(cm.adtg)
    e3:SetOperation(cm.adop)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(cm.sumcon)
    e4:SetCost(cm.sumcost)
    e4:SetTarget(cm.sumtg)
    e4:SetOperation(cm.sumop)
    c:RegisterEffect(e4)
    --self to grave
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_SELF_TOGRAVE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(cm.tgcon)
    c:RegisterEffect(e5)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return true end
    if chk==0 then return true end
    local op=0
    local off=1
    local ops={}
    local opval={}
    e:SetLabel(0)
    if cm.adcost(e,tp,eg,ep,ev,re,r,rp,0) and cm.adtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) then
        ops[off]=aux.Stringid(m,1)
        opval[off]=1
        off=off+1
    end
    if Duel.GetCurrentPhase()~=PHASE_DAMAGE and cm.sumcon(e,tp,eg,ep,ev,re,r,rp) and cm.sumcost(e,tp,eg,ep,ev,re,r,rp,0) and cm.sumtg(e,tp,eg,ep,ev,re,r,rp,0) then
        ops[off]=aux.Stringid(m,2)
        opval[off]=2
        off=off+1
    end
    if off~=1 then
        local op=0
        if Duel.GetCurrentPhase()==PHASE_DAMAGE then
            op=1
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
        else
            op=Duel.SelectOption(tp,aux.Stringid(m,0),table.unpack(ops))
        end
        if opval[op]==1 then
            e:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
            e:SetLabel(1)
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            cm.adtg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
        elseif opval[op]==2 then
            e:SetCategory(CATEGORY_SUMMON)
            e:SetLabel(2)
            Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
            cm.sumtg(e,tp,eg,ep,ev,re,r,rp,1)
        end
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local op=e:GetLabel()
    if op==0 then return end
    if op==1 then
        cm.adop(e,tp,eg,ep,ev,re,r,rp)
    elseif op==2 then
        cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    end
end
function cm.distg(e,c)
    return not c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.refilter(c)
    return c:IsFaceup() and mqt.ismqt(c) and c:IsReleasableByEffect(c)
end
function cm.adfilter(c)
    return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.refilter(chkc) and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(cm.refilter,tp,LOCATION_ONFIELD,0,1,c)
        and Duel.IsExistingMatchingCard(cm.adfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.refilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 and not tc:IsLocation(LOCATION_ONFIELD) then
        local g=Duel.GetMatchingGroup(cm.adfilter,tp,0,LOCATION_MZONE,nil)
        local tc2=g:GetFirst()
        while tc2 do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(-500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc2:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc2:RegisterEffect(e2)
            tc2=g:GetNext()
        end
    end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m+100)==0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
end
function cm.sumfilter(c)
    return c:IsSummonable(true,nil,1) and mqt.ismqt(c)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil,1)
    end
end
function cm.tgfilter(c)
    return c:IsFaceup() and mqt.ismqt(c) and not c:IsCode(m)
end
function cm.tgcon(e)
    local tp=e:GetHandlerPlayer()
    return (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil))
        or not Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
