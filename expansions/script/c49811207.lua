--盗読者エルビブ
function c49811207.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --levelup
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811207,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCost(c49811207.cost)
    e1:SetTarget(c49811207.tg)
    e1:SetOperation(c49811207.op)
    c:RegisterEffect(e1)
end
function c49811207.rmfilter(c)
    return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c49811207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c49811207.rmfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c49811207.rmfilter,tp,LOCATION_EXTRA,0,1,7,nil)  
    if Duel.Remove(g,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)~=0 then
        local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
        local ct=#og
        e:SetLabel(ct)
        local oc=og:GetFirst()
        while oc do
            oc:RegisterFlagEffect(49811207,RESET_EVENT+RESETS_STANDARD,0,1)
            oc=og:GetNext()
        end
        og:KeepAlive()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetLabelObject(og)
        e1:SetCondition(c49811207.retcon)
        e1:SetOperation(c49811207.retop)       
        Duel.RegisterEffect(e1,tp)
    end   
end
function c49811207.retfilter(c)
    return c:GetFlagEffect(49811207)~=0
end
function c49811207.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():IsExists(c49811207.retfilter,1,nil)
end
function c49811207.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c49811207.retfilter,nil,e:GetLabel())
    Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    g:DeleteGroup()
end
function c49811207.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsLevelAbove(1) end
end
function c49811207.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetValue(ct)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
