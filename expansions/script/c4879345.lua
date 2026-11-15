local s,id,o=GetID()
function s.initial_effect(c)
        local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.thcon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
     if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_DESTROYED)
        ge1:SetOperation(s.regop)
        Duel.RegisterEffect(ge1,0)
    end
end
function s.pfilter(c,tp)
    return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsSetCard(0x1df)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
        local ch=Duel.GetCurrentChain()
    if chkc then return chkc~=e:GetHandler() and chkc:IsOnField() end
    local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
    local b2=false
    if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
        if ch>1 then
        local se,p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
        local tep=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER)
        b2=se and se:GetHandler():IsSetCard(0x1df) and se:IsActiveType(TYPE_MONSTER) and p==tp and tep==1-tp and Duel.IsChainDisablable(ev)
    end
    if chk==0 then return  b1 or b2 end
    local op=0

        op=aux.SelectFromOptions(tp,
            {b1,aux.Stringid(id,2),1},
            {b2,aux.Stringid(id,3),2})

    e:SetLabel(op)
    if op==1 then
        if e:IsCostChecked() then
            e:SetCategory(0)
            e:SetProperty(0)
        end
    elseif op==2 then
        if e:IsCostChecked() then
            e:SetCategory(CATEGORY_DESTROY)
            e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        end
         e:SetCategory(CATEGORY_DISABLE)
        if tse then
            local og=Group.FromCards(tse:GetHandler())
            Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
        end
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==1 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
        if tc then
            Duel.SSet(tp,tc)
              if Duel.GetFlagEffect(tp,id)>0 then
if tc:IsType(TYPE_TRAP) then
local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
            e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
else
local e2=Effect.CreateEffect(tc)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
            e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
end
        end
    elseif e:GetLabel()==2 then
       local ch=Duel.GetCurrentChain()
        Duel.NegateEffect(ch-1)
        Duel.Destroy(ch-1,REASON_EFFECT)
    end
end
function s.dcfilter(c)
    return c:IsReason(REASON_EFFECT)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    if re and eg:IsExists(s.dcfilter,1,nil) and re:GetHandler():IsSetCard(0x1df) then
        Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
    end
end
function s.dcfilter(c)
    return c:IsReason(REASON_EFFECT)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return re and rp==tp and eg:IsExists(s.dcfilter,1,c) and re:GetHandler():IsSetCard(0x1df)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc~=e:GetHandler() and chkc:IsOnField() end
    local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil,tp)
    local b2=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
    if chk==0 then return e:IsCostChecked() or b1 or b2 end
    local op=0
    if e:IsCostChecked() then
        op=e:GetLabel()
    else
        op=aux.SelectFromOptions(tp,
            {b1,aux.Stringid(id,2),1},
            {b2,aux.Stringid(id,3),2})
    end
    e:SetLabel(op)
    if op==1 then
        if e:IsCostChecked() then
            e:SetCategory(0)
            e:SetProperty(0)
        end
    elseif op==2 then
        if e:IsCostChecked() then
            e:SetCategory(CATEGORY_DESTROY)
            e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==1 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    elseif e:GetLabel()==2 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToChain() and tc:IsOnField() then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end