--Wonderlands×Showtime 神代类
local m=131000017
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
    e2:SetDescription(aux.Stringid(131000017,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,131000017)
    e2:SetCondition(c131000017.negcon)
    e2:SetTarget(c131000017.negtg)
    e2:SetOperation(c131000017.negop)
    c:RegisterEffect(e2)
    --hand link
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,131000007)
    e1:SetValue(c131000017.matval)
    c:RegisterEffect(e1)
    
end
function c131000017.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and ep~=tp and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end

function c131000017.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c131000017.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e)  then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)  then
          Duel.Destroy(eg,REASON_EFFECT)    
          Duel.Destroy(c,REASON_EFFECT)
    end
end
function c131000017.mfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL)
end
function c131000017.exmfilter(c)
    return c:IsLocation(LOCATION_HAND) and c:IsCode(131000017)
end
function c131000017.matval(e,lc,mg,c,tp)
    if not lc:IsRace(RACE_MACHINE) then return false,nil end
    return true,not mg or  not mg:IsExists(c131000017.exmfilter,1,nil)
end