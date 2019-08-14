--天夜 风行者
function c60150623.initial_effect(c)
    c:SetUniqueOnField(1,0,60150623)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,c60150623.ffilter,aux.FilterBoolFunction(c60150623.ffilter2),false)
    --spsummon condition
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetValue(c60150623.splimit)
    c:RegisterEffect(e2)
    --battle target
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(aux.imval1)
    c:RegisterEffect(e6)
    --cannot target
    --local e7=Effect.CreateEffect(c)
    --e7:SetType(EFFECT_TYPE_SINGLE)
    --e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    --e7:SetRange(LOCATION_MZONE)
    --e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    --e7:SetValue(c60150623.tgvalue)
    --e7:SetCondition(c60150623.immcon)
    --c:RegisterEffect(e7)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetCondition(c60150623.immcon)
    e5:SetValue(c60150623.efilter)
    c:RegisterEffect(e5)
    --direct atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e3)
    --actlimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,1)
    e4:SetValue(c60150623.aclimit)
    e4:SetCondition(c60150623.actcon)
    c:RegisterEffect(e4)
end
function c60150623.ffilter(c)
    return c:IsSetCard(0x5b21) and c:IsType(TYPE_XYZ)
end
function c60150623.ffilter2(c)
    return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsType(TYPE_XYZ)
end
function c60150623.splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150623.tgvalue(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end
function c60150623.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE) then return true end
    if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then return true end
end
function c60150623.immcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()<=1 and e:GetHandler():IsFaceup()
end
function c60150623.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c60150623.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end