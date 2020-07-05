--梦想抹杀者
function c79029511.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029511)
	e1:SetCondition(c79029511.spcon)
	c:RegisterEffect(e1)  
	--can not SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c79029511.desop)
	e3:SetCondition(c79029511.descon)
	c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c79029511.efilter)
	c:RegisterEffect(e3)
end
function c79029511.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c79029511.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c79029511.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(tp) and tc==e:GetHandler()
		and bc:IsReason(REASON_BATTLE)
end
function c79029511.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	local flag=0
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
	local c=e:GetHandler()
	c:RegisterFlagEffect(79029511,RESET_PHASE+PHASE_END,0,1)
	local flag=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetLabel(flag)
	e1:SetTarget(c79029511.sumlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Debug.Message("收割的镰刀是浮生大梦的终曲，堕入比无间地狱更水深火热的真实中吧！")
end
function c79029511.sumlimit(e,c)
	return c:IsType(e:GetLabel())
end
function c79029511.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and te:GetHandler():IsLocation(LOCATION_ONFIELD)
end

