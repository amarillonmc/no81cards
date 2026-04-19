--时隙之罪
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.actcost)
    e1:SetTarget(s.acttg)
    e1:SetOperation(s.actop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.sscon)
    e2:SetTarget(s.sstg)
    e2:SetOperation(s.ssop)
    c:RegisterEffect(e2)
end
function s.sscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0,1,nil)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() and not e:GetHandler():IsStatus(STATUS_CHAINING) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase()
end
function s.actfilter(c,tp)
    return c:IsCode(4879171) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.filter1(c)
    return  c:GetFlagEffect(4879171)~=0
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0x3f,1,nil)
local b2=Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp)
    if chk==0 then return  b1 or b2 end
     local off=1
    local ops={}
    local opval={}
    if b1 then
        ops[off]=aux.Stringid(id,2)
        opval[off-1]=1
        off=off+1
    end
    if b2 then
        ops[off]=aux.Stringid(id,3)
        opval[off-1]=2
        off=off+1
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local op=Duel.SelectOption(tp,table.unpack(ops))
    e:SetLabel(opval[op])
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
     if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0x3f,0x3f,1,1,nil)
    if #g==0 then return end
    local tc=g:GetFirst()
    local turne=tc[tc]
    local op=turne:GetOperation()
    op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
    elseif op==2 then
        if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
    local g=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
    Duel.ResetFlagEffect(tp,15248873)
    local tc=g:GetFirst()
    if tc then
        local te=tc:GetActivateEffect()
        if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
        Duel.ResetFlagEffect(tp,15248873)
        local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
       local te1=tc:CheckActivateEffect(true,true,true) 
local op=te1:GetOperation()
if op then op(e,tp,eg,ep,ev,re,r,rp) end
        te:UseCountLimit(tp,1,true)
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
end