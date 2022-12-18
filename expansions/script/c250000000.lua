--卡通风暴密码人
function c250000000.initial_effect(c)
	aux.AddCodeList(c,15259703)
	c:EnableReviveLimit()
	--special summon
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c250000000.sdescon)
	e3:SetOperation(c250000000.sdesop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c250000000.dircon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetCondition(c250000000.atcon)
	e5:SetValue(c250000000.atlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e6:SetCondition(c250000000.atcon)
	c:RegisterEffect(e6)
	--cannot attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetOperation(c250000000.atklimit)
	c:RegisterEffect(e7)
	--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e8)
	--cannot attack emz
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e9:SetValue(c250000000.atlimit)
	c:RegisterEffect(e9)
	--immune
	local e10=e8:Clone()
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetValue(c250000000.immval)
	c:RegisterEffect(e10)
	--indes
	local e11=e9:Clone()
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e11)
end
function c250000000.atlimit(e,c)
	return c:GetSequence()>4
end
function c250000000.immval(e,te)
	return te:IsActivated() and te:GetActivateLocation()==LOCATION_MZONE and te:GetActivateSequence()>4
end
function c250000000.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c250000000.spcfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function c250000000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(c250000000.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and ft>-1 and Duel.CheckReleaseGroup(tp,c250000000.spcfilter,1,nil,ft,tp)
end
function c250000000.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c250000000.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c250000000.sfilter,1,nil)
end
function c250000000.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c250000000.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c250000000.dircon(e)
	return not Duel.IsExistingMatchingCard(c250000000.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c250000000.atcon(e)
	return Duel.IsExistingMatchingCard(c250000000.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c250000000.atlimit(e,c)
	return not c:IsType(TYPE_TOON) or c:IsFacedown()
end
function c250000000.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end


