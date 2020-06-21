--罗德岛·术士干员-远山
function c79029050.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83414006,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029050.condition)
	e1:SetTarget(c79029050.target)
	e1:SetOperation(c79029050.operation)
	c:RegisterEffect(e1)	
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c79029050.counter)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c79029050.actfilter)
	c:RegisterEffect(e3)
	--remove counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79029050.rmcon)
	e4:SetOperation(c79029050.rmop)
	c:RegisterEffect(e4)
end
function c79029050.actfilter(e,re,tp)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and tc:IsLevelBelow(c:GetCounter(0x1099)) or tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and   tc:IsRankBelow(c:GetCounter(0x1099))
end
function c79029050.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c79029050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
	end
end
function c79029050.counter(e,tp,eg,ep,ev,re,r,rp)
local tc=eg:GetFirst()
if tc:IsFaceup() and tc:IsControler(tp) then
	e:GetHandler():AddCounter(0x1099,1) 
end
end
function c79029050.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1099)>0
end
function c79029050.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1099,e:GetHandler():GetCounter(0x1099),REASON_EFFECT)
end