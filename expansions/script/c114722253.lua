function c114722253.initial_effect(c)
    aux.AddCodeList(c,46986414)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(aux.TargetBoolFunction(aux.TRUE))
    e1:SetOperation(c114722253.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c114722253.imtarget)
    e2:SetValue(aux.indoval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,114722253)
    e3:SetCondition(c114722253.cpcondition)
    e3:SetCost(c114722253.cpcost)
    e3:SetTarget(c114722253.cptarget)
    e3:SetOperation(c114722253.cpoperation)
    c:RegisterEffect(e3)
end
function c114722253.filter(c)
    return aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(114722253)
end
function c114722253.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local dg=Duel.GetMatchingGroup(c114722253.filter,tp,LOCATION_DECK,0,nil)
    local n=dg:GetClassCount(Card.GetCode)
    if n>Duel.GetLocationCount(tp,LOCATION_SZONE) then n=Duel.GetLocationCount(tp,LOCATION_SZONE) end
    if n>0 and Duel.SelectYesNo(tp,aux.Stringid(114722253,0)) then
        local m=Duel.DiscardHand(tp,Card.IsDiscardable,1,n,REASON_EFFECT+REASON_DISCARD)
        local hg=Group.CreateGroup()
        for i=1,m do
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local tc=dg:Select(tp,1,1,nil):GetFirst()
            hg:AddCard(tc)
            dg:Remove(Card.IsCode,nil,tc:GetCode())
        end
        Duel.SSet(tp,hg)
        for tc in aux.Next(hg) do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
            if tc:IsType(TYPE_QUICKPLAY) then e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN) end
            if tc:IsType(TYPE_TRAP) then e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN) end
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
function c114722253.imtarget(e,tg)
    return tg:IsType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler()~=tg
end
function c114722253.cfilter(c)
    return c:IsFaceup() and c:IsCode(46986414)
end
function c114722253.cpcondition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c114722253.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c114722253.cpfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,false,false)~=nil
end
function c114722253.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c114722253.cpfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c114722253.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
    local te=g:GetFirst():CheckActivateEffect(false,false,true)
    c114722253[Duel.GetCurrentChain()]=te
    Duel.SendtoGrave(g,REASON_COST)
    local cost=te:GetCost()
    if cost then cost(e,tp,eg,ep,ev,re,r,rp,chk) end
end
function c114722253.cptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local te=c114722253[Duel.GetCurrentChain()]
    if chkc then
        local tg=te:GetTarget()
        return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
    end
    if chk==0 then return true end
    if not te then return end
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c114722253.cpoperation(e,tp,eg,ep,ev,re,r,rp)
    local te=c114722253[Duel.GetCurrentChain()]
    if not te then return end
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end