--踏无暴威
local m=60159927
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60159927+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60159927.condition)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60159927.drcon1)
    e2:SetOperation(c60159927.drop1)
    c:RegisterEffect(e2)
end
function c60159927.cfilter(c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c60159927.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60159927.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159927.filter(c)
    return c:IsPreviousLocation(LOCATION_EXTRA)
end
function c60159927.drcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60159927.filter,1,nil) 
end
function c60159927.drop1(e,tp,eg,ep,ev,re,r,rp)
    local tp=eg:GetFirst():GetPreviousControler()
    Duel.SetLP(tp,Duel.GetLP(tp)/2)
end
