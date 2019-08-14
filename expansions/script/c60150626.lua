--天夜 暗炎
function c60150626.initial_effect(c)
    c:SetUniqueOnField(1,0,60150626)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,c60150626.ffilter,aux.FilterBoolFunction(c60150626.ffilter2),false)
    --spsummon condition
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetValue(c60150626.splimit)
    c:RegisterEffect(e2)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c60150626.efilter)
    c:RegisterEffect(e5)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c60150626.cost)
    e1:SetTarget(c60150626.target)
    e1:SetOperation(c60150626.operation)
    c:RegisterEffect(e1)
end
function c60150626.ffilter(c)
    return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150626.ffilter2(c)
    return c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c60150626.splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150626.efilter(e,te,tp)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
    else 
        if te:IsActiveType(TYPE_MONSTER) then
            local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
            local tc=g:GetFirst()
            local ttype=0
            while tc do
                ttype=bit.bor(tc:GetAttribute(),ttype)
                tc=g:GetNext()
            end
            local ec=te:GetOwner()
            return bit.band(ec:GetAttribute(),ttype)~=0 
        else
            return false
        end
    end
end
function c60150626.cfilter(c)
    return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150626.gfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150626.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150626.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c60150626.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 then
        local g2=g:Filter(c60150626.gfilter,nil)
        if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
            local sg=g2:Select(tp,1,1,nil)
            local tc2=sg:GetFirst()
            while tc2 do
                if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
                tc2=sg:GetNext()
            end
            Duel.SendtoExtraP(sg,nil,REASON_COST)
        else
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150642,2))
            local sg=g:Select(tp,1,1,nil)
            local tc2=sg:GetFirst()
            while tc2 do
                if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
                tc2=sg:GetNext()
            end
            Duel.SendtoDeck(sg,nil,2,REASON_COST)
        end
    end
end
function c60150626.filter2(c,ttype2)
    return c:IsFaceup() and c:IsControlerCanBeChanged() and not c:IsDisabled() and not c:IsAttribute(ttype2)
end
function c60150626.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    local ttype2=0
    while tc do
        ttype2=bit.bor(tc:GetAttribute(),ttype2)
        tc=g:GetNext()
    end
    if chk==0 then return Duel.IsExistingMatchingCard(c60150626.filter2,tp,0,LOCATION_MZONE,1,nil,ttype2) end
    local g=Duel.GetMatchingGroup(c60150626.filter2,tp,0,LOCATION_MZONE,nil,ttype2)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL+CATEGORY_DISABLE,g,1,0,0)
end
function c60150626.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    local ttype2=0
    while tc do
        ttype2=bit.bor(tc:GetAttribute(),ttype2)
        tc=g:GetNext()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectMatchingCard(tp,c60150626.filter2,tp,0,LOCATION_MZONE,1,1,nil,ttype2)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        Duel.HintSelection(g)
        Duel.GetControl(tc,tp)
    end
end
