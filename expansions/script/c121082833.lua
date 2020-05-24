--新混沌
local m=121082833
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_PREDRAW)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    e0:SetRange(LOCATION_HAND+LOCATION_DECK)
    e0:SetOperation(cm.op)
    c:RegisterEffect(e0)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_CANNOT_SSET)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e8)
end
function cm.effilter(c)
    return c:IsFaceup() and c:GetOriginalCode()==m
end
function cm.effcon(e)
    return Duel.IsExistingMatchingCard(cm.effilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetTargetRange(1,1)
    e2:SetCondition(cm.effcon)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetValue(m)
    Duel.RegisterEffect(e2,tp)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_FZONE)
    e7:SetCode(EFFECT_SEND_REPLACE)
    e7:SetTarget(aux.TRUE)
    e7:SetValue(aux.TRUE)
    c:RegisterEffect(e7)
end
