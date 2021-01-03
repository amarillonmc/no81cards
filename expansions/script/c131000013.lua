--混沌终结支配者 -开辟与终焉的支配者-
local m=131000013
local cm=_G["c"..m]
function cm.initial_effect(c)
        c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c131000013.spcon)
    e1:SetOperation(c131000013.spop)
    c:RegisterEffect(e1)
    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c131000013.spsumsuc)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c131000013.rmcost)
    e3:SetTarget(c131000013.rmtg)
    e3:SetOperation(c131000013.rmop)
    c:RegisterEffect(e3)
end
function c131000013.spcostfilter1(c)
    return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c131000013.spcostfilter2(c)
    return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
end
function c131000013.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetMZoneCount(tp)<=0 then return false end
    return Duel.IsExistingMatchingCard(c131000013.spcostfilter1,tp,LOCATION_GRAVE,0,1,nil)
and        Duel.IsExistingMatchingCard(c131000013.spcostfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c131000013.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c131000013.spcostfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c131000013.spcostfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function c131000013.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(c131000013.chlimit)
end
function c131000013.chlimit(e,ep,tp)
    return tp==ep
end
function c131000013.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000)  end
    Duel.PayLPCost(tp,1000)
end
function c131000013.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,e:GetHandler()) 
            and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,e:GetHandler()) 

    end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c131000013.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,aux.ExceptThisCard(e))
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if ct~=0 then
        Duel.Damage(1-tp,ct*500,REASON_EFFECT)
    end
end