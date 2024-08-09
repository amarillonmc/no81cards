--混沌の禁断魔導陣
function c114722253.initial_effect(c)
    aux.AddCodeList(c,46986414)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c114722253.activate)
    c:RegisterEffect(e1)
    --indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c114722253.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --copy spell/trap
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1,114722253)
    e3:SetCondition(c114722253.stcon)
    e3:SetCost(c114722253.stcost)
    e3:SetTarget(c114722253.sttg)
    e3:SetOperation(c114722253.stop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_CHAINING)
    e4:SetTarget(c114722253.sttg2)
    c:RegisterEffect(e4)
end
c114722253.card_code_list={46986414}
function c114722253.filter(c)
    return aux.IsCodeListed(c,46986414) and c:IsSSetable() and not c:IsCode(114722253)
end
function c114722253.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local dg=Duel.GetMatchingGroup(c114722253.filter,tp,LOCATION_DECK,0,nil)
    local n=dg:GetClassCount(Card.GetCode)
    if n>Duel.GetLocationCount(tp,LOCATION_SZONE) then n=Duel.GetLocationCount(tp,LOCATION_SZONE) end
    if n>0 and Duel.SelectYesNo(tp,aux.Stringid(114722253,2)) then
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

function c114722253.indtg(e,c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler()~=c
end

function c114722253.cfilter(c)
    return c:IsFaceup() and c:IsCode(46986414)
end
function c114722253.stcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c114722253.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

--[[
function c114722253.stfilter(c,tp,eg,ep,ev,re,r,rp)
    local te=c:GetActivateEffect()
    if not te then return false end
    local condition=te:GetCondition()
    local cost=te:GetCost()
    local target=te:GetTarget()
    local op=te:GetOperation()
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(114722253)
        and (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
        and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) and op and c:IsAbleToGraveAsCost()
end
]]

function c114722253.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c114722253.sefilter(c)
    local te=c:GetActivateEffect()
    if not te then return false end
    local op=te:GetOperation()
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_EQUIP) and not c:IsCode(114722253) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,true,false)~=nil and c:CheckActivateEffect(false,false,false)~=nil and op
end
function c114722253.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(c114722253.sefilter,tp,LOCATION_DECK,0,1,nil) and not Duel.CheckEvent(EVENT_CHAINING)
    end
    e:SetLabel(0)
    local g=Duel.SelectMatchingCard(tp,c114722253.sefilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,false) and g:GetFirst():CheckActivateEffect(false,false,false)
    e:SetProperty(te:GetProperty())
    local fcos=te:GetCost()
    local tg=te:GetTarget()
    if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,chk) end
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.ClearOperationInfo(0)
end
function c114722253.stop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local te=e:GetLabelObject()
    if not te then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c114722253.sefilter2(c,e,tp,eg,ep,ev,re,r,rp)
    if c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_EQUIP) and not c:IsCode(114722253) and c:IsAbleToGraveAsCost() then
        if c:CheckActivateEffect(false,false,false)~=nil then return true end
        local te=c:GetActivateEffect()
        local op=te:GetOperation()
        if not op then return false end
        if te:GetCode()~=EVENT_CHAINING then return false end
        local con=te:GetCondition()
        if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
        local cost=te:GetCost()
        if cost and not cost(te,tp,eg,ep,ev,re,r,rp,0) then return false end
        local tg=te:GetTarget()
        if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
        return true
    else return false end
end
function c114722253.sttg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(c114722253.sefilter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c114722253.sefilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoGrave(g,REASON_COST)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    local tc=g:GetFirst()
    local te,ceg,cep,cev,cre,cr,crp
    local fchain=c114722253.sefilter(tc)
    if fchain then
        te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,false)
    else
        te=tc:GetActivateEffect()
    end
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    local fcos=te:GetCost()
    if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,chk) end
    if tg then
        if fchain then
            tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
        else
            tg(e,tp,eg,ep,ev,re,r,rp,1)
        end
    end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.ClearOperationInfo(0)
end
