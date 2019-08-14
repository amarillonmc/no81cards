--天夜 瞬斩
function c60150625.initial_effect(c)
	c:SetUniqueOnField(1,0,60150625)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150625.ffilter,aux.FilterBoolFunction(c60150625.ffilter2),false)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150625.splimit)
	c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(aux.bdocon)
    e2:SetOperation(c60150625.desop)
    c:RegisterEffect(e2)
    --attack again
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(c60150625.atkfilter)
    c:RegisterEffect(e4)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetOperation(c60150625.negop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetOperation(c60150625.negop)
	c:RegisterEffect(e7)
end
function c60150625.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150625.ffilter2(c)
	return c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60150625.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150625.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(60150625,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c60150625.atkfilter(e)
	return e:GetHandler():GetFlagEffect(60150625)
end
function c60150625.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
	if bc==nil then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetTarget(c60150625.sumlimit)
    e1:SetLabel(bc:GetCode())
    if Duel.GetTurnPlayer()==tp then
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
    end
    Duel.RegisterEffect(e1,tp)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetValue(c60150625.aclimit)
    Duel.RegisterEffect(e4,tp)
end
function c60150625.sumlimit(e,c)
    return c:IsCode(e:GetLabel())
end
function c60150625.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end