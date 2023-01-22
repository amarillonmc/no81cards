function c118776531.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c118776531.sumcon)
    e1:SetTarget(c118776531.target1)
    e1:SetOperation(c118776531.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c118776531.chainop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,118776531)
    e3:SetCondition(c118776531.sumcon)
    e3:SetTarget(c118776531.target2)
    e3:SetOperation(c118776531.activate)
    e3:SetLabel(1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,98725103)
    e4:SetCondition(c118776531.shcon)
    e4:SetTarget(c118776531.shtg)
    e4:SetOperation(c118776531.shop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e5:SetCondition(c118776531.actcon)
    c:RegisterEffect(e5)
end
function c118776531.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c118776531.sumfilter(c)
    return c:IsSetCard(0xf9) and c:IsSummonable(true,nil,1)
end
function c118776531.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:SetLabel(0)
    if Duel.IsExistingMatchingCard(c118776531.sumfilter,tp,LOCATION_HAND,0,1,nil)
        and Duel.GetFlagEffect(tp,118776531)==0 and Duel.SelectYesNo(tp,94) then
        e:SetLabel(1)
        Duel.RegisterFlagEffect(tp,118776531,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c118776531.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if e:GetLabel()~=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c118776531.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil,1)
    end
end
function c118776531.chainop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsSetCard(0xf9) then
        Duel.SetChainLimit(c118776531.chainlm)
    end
end
function c118776531.chainlm(e,rp,tp)
    return tp==rp
end
function c118776531.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,118776531)==0
        and Duel.IsExistingMatchingCard(c118776531.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.RegisterFlagEffect(tp,118776531,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c118776531.shcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c118776531.shfilter(c,tp)
    return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xf9) and not c:IsCode(118776531) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c118776531.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c118776531.shfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c118776531.shop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectMatchingCard(tp,c118776531.shfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local b1=tc:IsAbleToHand()
        local b2=tc:GetActivateEffect():IsActivatable(tp)
        if b1 and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not b2 or Duel.SelectYesNo(tp,aux.Stringid(118776531,0))) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local te=tc:GetActivateEffect()
            local tep=tc:GetControler()
            local cost=te:GetCost()
            if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
        end
        local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
        if dg:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,57761191,21377582) and Duel.SelectYesNo(tp,aux.Stringid(118776531,1)) then
            Duel.BreakEffect()
            Duel.Destroy(dg,REASON_EFFECT)
        end
    end
end
function c118776531.actcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp 
        and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
