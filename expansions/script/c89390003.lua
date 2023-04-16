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
    e6:SetCondition(cm.limcon)
    e6:SetOperation(cm.chainop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(m,0))
    e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e7:SetTarget(cm.destg)
    e7:SetOperation(cm.desop)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetDescription(aux.Stringid(m,1))
    e8:SetTarget(cm.destg2)
    e8:SetOperation(cm.desop2)
    c:RegisterEffect(e8)
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
    if c:IsSummonType(SUMMON_TYPE_FUSION) and g:IsExists(Card.IsFusionCode,1,nil,89390000) and g:IsExists(Card.IsFusionCode,1,nil,89390001) and g:IsExists(Card.IsFusionCode,1,nil,89390002) and c:GetFlagEffect(m)>0 then
        Duel.SetChainLimitTillChainEnd(cm.chainlm)
    end
    c:ResetFlagEffect(m)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(cm.chainlm)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(tp,gc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
        local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if oc>0 then
            Duel.Draw(tp,oc,REASON_EFFECT)
        end
    end
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local gc=g:GetCount()
    if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(1-tp,gc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,gc)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local gc=g:GetCount()
    if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
        local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if oc>0 then
            Duel.Draw(1-tp,oc,REASON_EFFECT)
        end
    end
end
