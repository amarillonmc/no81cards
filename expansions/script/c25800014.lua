--绫波改
function c25800014.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,25800011,25800008,25800104,true,true)
	aux.EnableChangeCode(c,25800013,LOCATION_MZONE+LOCATION_GRAVE)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c25800014.regcon)
	e1:SetOperation(c25800014.regop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c25800014.atkval)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end
function c25800014.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c25800014.atkval(e,c)
	return Duel.GetMatchingGroupCount(c25800014.atkfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*400
end
----
---
function c25800014.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c25800014.regop(e,tp,eg,ep,ev,re,r,rp)
	--unaffected handle after it was summoned
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c25800014.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	e:GetHandler():RegisterEffect(e1)
end
function c25800014.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end