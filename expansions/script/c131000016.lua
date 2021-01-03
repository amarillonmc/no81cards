--Wonderlands×Showtime 草薙宁宁
local m=131000016
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e10=Effect.CreateEffect(c)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetRange(LOCATION_GRAVE+LOCATION_HAND)
    e10:SetCode(EFFECT_SPSUMMON_CONDITION)
    e10:SetValue(aux.FALSE)
    c:RegisterEffect(e10)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000016,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,131000016)
    e2:SetCondition(c131000016.negcon)
    e2:SetTarget(c131000016.negtg)
    e2:SetOperation(c131000016.negop)
    c:RegisterEffect(e2)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_DECK)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCountLimit(1,131000016+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c131000016.spcon)
    c:RegisterEffect(e1)
    
end
function c131000016.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and ep~=tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end

function c131000016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c131000016.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e)  then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)  then
          Duel.Destroy(eg,REASON_EFFECT)  
          Duel.Destroy(c,REASON_EFFECT)
    end
end
function c131000016.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c131000016.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c131000016.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
