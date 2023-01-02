--原生种·监察官
local m=89390003
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.limcon)
    e1:SetOperation(cm.limop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e0=e1:Clone()
    e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e0)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_CHAIN_END)
    e5:SetOperation(cm.limop2)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAINING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetOperation(cm.chainop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TODECK)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(cm.destg)
    e7:SetOperation(cm.desop)
    c:RegisterEffect(e7)
end
function cm.ffilter(c,fc,sub,mg,sg)
    return c:IsRace(RACE_PSYCHO) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.chainlm(e,rp,tp)
    return tp==rp
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    return c:IsSummonType(SUMMON_TYPE_FUSION) and g:IsExists(Card.IsFusionCode,1,nil,89390000) and g:IsExists(Card.IsFusionCode,1,nil,89390001) and g:IsExists(Card.IsFusionCode,1,nil,89390002)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()==0 then
        Duel.SetChainLimitTillChainEnd(cm.chainlm)
    elseif Duel.GetCurrentChain()==1 then
        e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    if c:IsSummonType(SUMMON_TYPE_FUSION) and g:IsExists(Card.IsFusionCode,1,nil,89390000) and g:IsExists(Card.IsFusionCode,1,nil,89390001) and g:IsExists(Card.IsFusionCode,1,nil,89390002) and c:GetFlagEffect(m)~=0 then
        Duel.SetChainLimitTillChainEnd(cm.chainlm)
    end
    c:ResetFlagEffect(m)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(cm.chainlm)
end
function cm.gyfilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsAbleToDeck()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.gyfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local n1=Duel.GetMatchingGroupCount(cm.gyfilter,tp,LOCATION_REMOVED,0,nil)
    local n2=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
    local n3=1
    for i=2,99 do
        if Duel.IsPlayerCanDraw(tp,i) then n3=i end
    end
    local n4=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local n5=1
    for i=2,99 do
        if Duel.IsPlayerCanDraw(1-tp,i) then n5=i end
    end
    local dc=math.min(n1,n2,n3+1,n4,n5-1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local gy=Duel.SelectMatchingCard(tp,cm.gyfilter,tp,LOCATION_REMOVED,0,1,dc,nil)
    if #gy==0 then return end
    local yc=Duel.SendtoDeck(gy,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    if yc<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,yc,yc,nil)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,yc)
    g:Merge(g1)
    if #g>0 then
        local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if ct>0 then
            Duel.BreakEffect()
            Duel.Draw(tp,yc+1,REASON_EFFECT)
            Duel.Draw(1-tp,yc-1,REASON_EFFECT)
        end
    end
end
