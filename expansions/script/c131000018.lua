--Wonderlands×Showtime 天马司
local m=131000018
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
    e2:SetDescription(aux.Stringid(131000018,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,131000018)
    e2:SetCondition(c131000018.negcon)
    e2:SetTarget(c131000018.negtg)
    e2:SetOperation(c131000018.negop)
    c:RegisterEffect(e2)  
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetDescription(aux.Stringid(131000018,1))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,131000008)
    e1:SetCondition(c131000018.condition2)
    e1:SetCost(c131000018.cost2)
    e1:SetOperation(c131000018.operation2)
    c:RegisterEffect(e1)
end
function c131000018.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function c131000018.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c131000018.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e)  then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)  then
          Duel.Destroy(eg,REASON_EFFECT)  
          Duel.Destroy(c,REASON_EFFECT)
    end
end
function c131000018.condition2(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsType(TYPE_RITUAL) and a:IsRelateToBattle())
        or (d:GetControler()==tp and d:IsType(TYPE_RITUAL) and d:IsRelateToBattle()))
end
function c131000018.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c131000018.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetOwnerPlayer(tp)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    if a:GetControler()==tp then
        e1:SetValue(d:GetAttack())
        a:RegisterEffect(e1)
    else
        e1:SetValue(a:GetAttack())
        d:RegisterEffect(e1)
    end
end
