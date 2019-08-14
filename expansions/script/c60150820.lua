--爱莎-赫尼尔时空
function c60150820.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b23),2,2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_ACTIVATING)
    e3:SetOperation(c60150820.disop)
    c:RegisterEffect(e3)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
    e1:SetCountLimit(1)
    e1:SetCondition(c60150820.condition)
    e1:SetTarget(c60150820.target)
    e1:SetOperation(c60150820.operation)
    c:RegisterEffect(e1)
end
function c60150820.disop(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    local rc=re:GetHandler()
    if rc:GetFlagEffect(60150820)~=0 then return end
    if rc:IsLocation(LOCATION_ONFIELD) then 
        Duel.Hint(HINT_CARD,0,60150820)
        if not rc:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(60150820,1)) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(60150820,0))
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(LOCATION_REMOVED)
            rc:RegisterEffect(e1,true)
            rc:RegisterFlagEffect(60150820,RESET_EVENT+0x1fe0000,0,1)
        end
    end
end
function c60150820.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60150820.filter(c)
    return c:IsFaceup() and c:GetFlagEffect(60150820)>0 
end
function c60150820.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(c60150820.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>=1 end
    local g=Duel.GetMatchingGroup(c60150820.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c60150820.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150820.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    local g2=g:Filter(Card.IsAbleToHand,nil)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150820,2))
    local sg=g2:Select(tp,1,1,nil)
    if sg:GetCount()>0 then
        Duel.HintSelection(sg)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end